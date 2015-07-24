#!ruby
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
    boot_wait: '30s',
    boot_command: [
      'root<enter>',
      'echo http://{{ .HTTPIP }}:{{ .HTTPPort}} > .packer_http<enter>',
      'mkdir -m 0700 .ssh<enter>',
      'curl $(cat .packer_http)/install_rsa.pub > .ssh/authorized_keys<enter>',
      'start sshd<enter>',
    ],
    http_directory: 'scripts',
    iso_checksum_type: 'sha256',
    shutdown_command: 'shutdown -h now',
    ssh_key_path: './scripts/install_rsa',
    ssh_port: 22,
    ssh_username: 'root',
  }.merge(opts)
end

def gen_template(
        arch:,
        iso_url:,
        iso_sha256:,
        virtualbox_guest_os:
)
  md = %r[/nixos-(\d+\.[^/]+)/].match(iso_url)
  raise "version not found in url" unless md
  full_version = md[1]
  ver = gen_version(full_version, 2)
  artifact = "zimbatm/nixos-#{ver}-#{arch}"

  puts JSON.pretty_generate(
    builders: [
      builder(
        type: 'virtualbox-iso',
        iso_url: iso_url,
        iso_checksum: iso_sha256,
        guest_additions_mode: 'disable',
        guest_os_type: virtualbox_guest_os,
        virtualbox_version_file: '.vbox_version',
      ),
      builder(
        type: 'vmware-iso',
        iso_url: iso_url,
        iso_checksum: iso_sha256,
        guest_os_type: 'other', # TODO, depend on arch
      )
    ],
    provisioners: [
      { type: 'shell', script: './scripts/install.sh' }
    ],
    'post-processors': [[
      {
        type: 'vagrant',
        keep_input_artifact: false,
      },
      {
        type: 'atlas',
        only: ['virtualbox-iso'],
        artifact: artifact,
        artifact_type: 'vagrant.box',
        metadata: {
          provider: 'virtualbox',
          version: gen_version(full_version, 3),
          description: <<-DESC
A minimal NixOS build based on the #{File.basename iso_url}.

See https://github.com/zimbatm/nixbox for project details.
          DESC
        }
      },
      {
        type: 'atlas',
        only: ['vmware-iso'],
        artifact: artifact,
        artifact_type: 'vagrant.box',
        metadata: {
          provider: 'vmware',
          version: gen_version(full_version, 3),
          description: <<-DESC
A minimal NixOS build based on the #{File.basename iso_url}.

See https://github.com/zimbatm/nixbox for project details.
          DESC
        }
      }
    ]],
    push: {
      name: artifact,
      vcs: true,
    },
  )
end
