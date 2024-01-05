# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

arch = ENV["ARCH"]

Vagrant.configure("2") do |config|
  config.vm.box = "nixbox-" + arch.to_s
  config.vm.disk :disk, size: "50GB", primary: true
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "4096"
  end

  config.vm.provider "qemu" do |qe|
    qe.arch = "x86_64"
    qe.machine = "q35"
    qe.cpu = "max"
    qe.net_device = "virtio-net-pci"
    qe.memory = "1024"
    qe.qemu_dir = "/usr/lib/qemu"
  end

  config.ssh.insert_key = false
end
