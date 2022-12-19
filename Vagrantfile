# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

arch = ENV["ARCH"]

Vagrant.configure("2") do |config|
  config.vm.box = "nixbox-" + arch.to_s
  config.disksize.size = '50GB'
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "4096"
  end

  config.ssh.insert_key = false
end
