packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.1.0"
    }
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = "~> 1"
    }
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = "~> 1"
    }
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = "~> 1.1.1"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
  }
}

locals {
  iso_url = "https://channels.nixos.org/nixos-${var.version}/latest-nixos-minimal-${var.arch}-linux.iso"
}

variable "builder" {
  description = "builder"
  type = string
}

variable "version" {
  description = "The version of NixOS to build"
  type = string
}

variable "arch" {
  description = "The system architecture of NixOS to build (Default: x86_64)"
  type = string
  default = "x86_64"
}

variable "iso_checksum" {
  description = "A ISO SHA256 value"
  type = string
}

variable "disk_size" {
  type    = string
  default = "10240"
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "boot_wait" {
  description = "The amount of time to wait for VM boot"
  type = string
  default = "120s"
}

variable "qemu_accelerator" {
  type    = string
  default = "kvm"
}

variable "cloud_repo" {
  type    = string
  default = "nixbox/nixos"
}

variable "cloud_token" {
  type    = string
  default = "${env("ATLAS_TOKEN")}"
}

variable "vagrant_cloud_arch" {
  type    = map(string)
  default = {
    "i386" = "i386"
    "x86-64" = "amd64"
    "aarch64" = "arm64"
  }
}

source "hyperv-iso" "hyperv" {
  boot_command         = [
    "mkdir -m 0700 .ssh<enter>",
    "curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/install_ed25519.pub > .ssh/authorized_keys<enter>",
    "sudo su --<enter>", "nix-env -iA nixos.linuxPackages.hyperv-daemons<enter><wait10>",
    "$(find /nix/store -executable -iname 'hv_kvp_daemon' | head -n 1)<enter><wait10>",
    "systemctl start sshd<enter>"
  ]
  boot_wait            = var.boot_wait
  communicator         = "ssh"
  differencing_disk    = true
  disk_size            = var.disk_size
  enable_secure_boot   = false
  generation           = 1
  headless             = true
  http_directory       = "scripts"
  iso_checksum         = var.iso_checksum
  iso_url              = local.iso_url
  memory               = var.memory
  shutdown_command     = "sudo shutdown -h now"
  ssh_port             = 22
  ssh_private_key_file = "./scripts/install_ed25519"
  ssh_timeout          = "1h"
  ssh_username         = "nixos"
  switch_name          = "Default Switch"
}

source "qemu" "qemu" {
  boot_command         = [
    "mkdir -m 0700 .ssh<enter>",
    "curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/install_ed25519.pub > .ssh/authorized_keys<enter>",
    "sudo systemctl start sshd<enter>"
  ]
  boot_wait            = var.boot_wait
  disk_interface       = "virtio-scsi"
  disk_size            = var.disk_size
  format               = "qcow2"
  headless             = true
  http_directory       = "scripts"
  iso_checksum         = var.iso_checksum
  iso_url              = local.iso_url
  qemuargs = [
    ["-m", var.memory],
    [ "-netdev", "user,hostfwd=tcp::{{ .SSHHostPort }}-:22,id=forward"],
    [ "-device", "virtio-net,netdev=forward,id=net0"]
  ]
  shutdown_command     = "sudo shutdown -h now"
  ssh_port             = 22
  ssh_private_key_file = "./scripts/install_ed25519"
  ssh_username         = "nixos"
}

source "qemu" "qemu-efi" {
  boot_command         = [
    "mkdir -m 0700 .ssh<enter>",
    "curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/install_ed25519.pub > .ssh/authorized_keys<enter>",
    "sudo systemctl start sshd<enter>"
  ]
  boot_wait            = var.boot_wait
  disk_interface       = "virtio-scsi"
  disk_size            = var.disk_size
  format               = "qcow2"
  headless             = true
  http_directory       = "scripts"
  iso_checksum         = var.iso_checksum
  iso_url              = local.iso_url
  qemuargs = [
    ["-m", var.memory],
    [ "-netdev", "user,hostfwd=tcp::{{ .SSHHostPort }}-:22,id=forward"],
    [ "-device", "virtio-net,netdev=forward,id=net0"]
  ]
  shutdown_command     = "sudo shutdown -h now"
  machine_type         = "q35"
  ssh_port             = 22
  ssh_private_key_file = "./scripts/install_ed25519"
  ssh_username         = "nixos"
  efi_firmware_code    = "./efi_data/OVMF_CODE_4M.ms.fd"
  #efi_firmware_vars    = "./efi_data/OVMF_VARS_4M.ms.fd"
}

source "virtualbox-iso" "virtualbox" {
  boot_command         = [
    "mkdir -m 0700 .ssh<enter>",
    "echo '{{ .SSHPublicKey }}' > .ssh/authorized_keys<enter>",
    "sudo systemctl start sshd<enter>"
  ]
  boot_wait            = "45s"
  disk_size            = var.disk_size
  format               = "ova"
  guest_additions_mode = "disable"
  guest_os_type        = "Linux_64"
  headless             = true
  http_directory       = "scripts"
  iso_checksum         = var.iso_checksum
  iso_url              = local.iso_url
  shutdown_command     = "sudo shutdown -h now"
  ssh_port             = 22
  ssh_username         = "nixos"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--memory", var.memory, "--vram", "128", "--clipboard", "bidirectional"]]
}

source "virtualbox-iso" "virtualbox-efi" {
  boot_command         = [
    "mkdir -m 0700 .ssh<enter>",
    "echo '{{ .SSHPublicKey }}' > .ssh/authorized_keys<enter>",
    "sudo systemctl start sshd<enter>"
  ]
  boot_wait            = "55s"
  disk_size            = var.disk_size
  format               = "ova"
  guest_additions_mode = "disable"
  guest_os_type        = "Linux_64"
  headless             = true
  http_directory       = "scripts"
  iso_checksum         = var.iso_checksum
  iso_url              = local.iso_url
  iso_interface        = "sata"
  shutdown_command     = "sudo shutdown -h now"
  ssh_port             = 22
  ssh_username         = "nixos"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--memory", var.memory, "--vram", "128", "--clipboard", "bidirectional", "--firmware", "EFI"]]
}

source "vmware-iso" "vmware" {
  boot_command         = [
    "mkdir -m 0700 .ssh<enter>",
    "curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/install_ed25519.pub > .ssh/authorized_keys<enter>",
    "sudo systemctl start sshd<enter>"
  ]
  boot_wait            = "45s"
  disk_size            = var.disk_size
  guest_os_type        = "Linux"
  headless             = true
  http_directory       = "scripts"
  iso_checksum         = var.iso_checksum
  iso_url              = local.iso_url
  memory               = var.memory
  shutdown_command     = "sudo shutdown -h now"
  ssh_port             = 22
  ssh_private_key_file = "./scripts/install_ed25519"
  ssh_username         = "nixos"
}

build {
  sources = [
    "source.hyperv-iso.hyperv",
    "source.qemu.qemu",
    "source.qemu.qemu-efi",
    "source.virtualbox-iso.virtualbox",
    "source.virtualbox-iso.virtualbox-efi",
    "source.vmware-iso.vmware"
  ]

  provisioner "shell" {
    execute_command = "sudo su -c '{{ .Vars }} {{ .Path }}'"
    script          = "./scripts/install.sh"
  }
    
  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = false
      only                = ["virtualbox-iso.virtualbox", "qemu.qemu", "hyperv-iso.hyperv", "virtualbox-iso.virtualbox-efi", "qemu.qemu-efi"]
      output              = "nixos-${var.version}-${var.builder}-${var.arch}.box"
    }
    post-processor "vagrant-cloud" {
      only                = ["virtualbox-iso.virtualbox", "qemu.qemu", "hyperv-iso.hyperv"]
      access_token        = "${var.cloud_token}"
      box_tag             = "${var.cloud_repo}"
      version             = "${var.version}"
      architecture        = "${lookup(var.vagrant_cloud_arch, var.arch, "amd64")}"
    }
    post-processor "vagrant-cloud" {
      only                = ["virtualbox-iso.virtualbox-efi", "qemu.qemu-efi"]
      access_token        = "${var.cloud_token}"
      box_tag             = "${var.cloud_repo}"
      version             = "${var.version}-efi"
      architecture        = "${lookup(var.vagrant_cloud_arch, var.arch, "amd64")}"
    }
  }
}
