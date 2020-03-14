#!/usr/bin/env nix-shell
#!nix-shell -i ruby
#
# Packer supports user variables but they are a bit awkward to use. It's
# easier to build the config programatically.
#
# The gen_template method is invoked by nixos-i686.rb and nixos-x86_64.rb
# respectively to avoid repetition.
#

require 'json'

def gen_version(version, components=3)
  version.split('.')[0..components-1].join('.')
end

def builder(**opts)
  {
    boot_wait: '45s',
    boot_command: [
      'echo http://{{ .HTTPIP }}:{{ .HTTPPort}} > .packer_http<enter>',
      'mkdir -m 0700 .ssh<enter>',
      'curl $(cat .packer_http)/install_rsa.pub > .ssh/authorized_keys<enter>',
      'sudo systemctl start sshd<enter>',
    ],
    http_directory: 'scripts',
    iso_checksum_type: 'sha256',
    shutdown_command: 'sudo shutdown -h now',
    ssh_private_key_file: './scripts/install_rsa',
    ssh_port: 22,
    ssh_username: 'nixos',
    headless: true
  }.merge(opts)
end

def gen_template(
        arch:,
        iso_url:,
        iso_sha256:,
        user: 'nixos'
)
  md = %r[/nixos-(\d+\.[^/]+)/].match(iso_url)
  raise "version not found in url" unless md
  full_version = md[1]
  ver = gen_version(full_version, 2)
  version = gen_version(full_version, 3) + "-1"
  artifact = "#{user}/nixos-#{ver}-#{arch}"
  build = "#{user}/nixos-#{arch}"
  guest_os_type =
    case arch
    when 'x86_64' then 'Linux_64'
    when 'i686' then 'Linux'
    else throw "Unknown guest os type for arch #{arch}"
    end

  puts JSON.pretty_generate(
    variables: {
      disk_size: '10240',
      memory: '1024',
    },
    builders: [
      builder(
        type: 'virtualbox-iso',
        iso_url: iso_url,
        iso_checksum: iso_sha256,
        guest_additions_mode: 'disable',
        format: 'ova',
        guest_os_type: guest_os_type,
        disk_size: '{{ user `disk_size` }}',
        vboxmanage: [
          ['modifyvm', '{{.Name}}', '--memory', '{{ user `memory` }}', '--vram', '128', '--clipboard', 'bidirectional'],
        ],
      ),
      builder(
        type: 'qemu',
        iso_url: iso_url,
        iso_checksum: iso_sha256,
        disk_interface: 'virtio-scsi',
        disk_size: '{{ user `disk_size` }}',
        format: 'qcow2',
        qemuargs: [
          ['-m', '{{ user `memory` }}'],
        ],
      ),
      builder(
        type: 'vmware-iso',
        iso_url: iso_url,
        iso_checksum: iso_sha256,
        memory: '{{ user `memory` }}',
        disk_size: '{{ user `disk_size` }}',
        guest_os_type: "Linux"
      ),
    ],
    provisioners: [
      {
        execute_command: "sudo su -c '{{ .Vars }} {{.Path}}'",
        type: 'shell',
        script: './scripts/install.sh'
      }
    ],
    'post-processors': [[
      {
        type: 'vagrant',
        keep_input_artifact: false,
        only: [ 'virtualbox-iso', 'qemu'],
        output: "nixos-#{ver}-{{.Provider}}-#{arch}.box"
      }
    ]],
  )
end

# main
arch = ARGV[0] || fail('usage: gen_template.rb <ARCH>')
isos = JSON.load(open('iso_urls.json'), nil, symbolize_names: true, create_additions: false)
config = isos[arch.to_sym] || fail("iso not found for arch #{arch}")
gen_template(arch: arch, **config)
