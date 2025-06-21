NixOS boxes for Vagrant
=======================

[NixOS](http://nixos.org) is a linux distribution based on a purely functional
package manager. This project builds [vagrant](http://vagrantup.com) .box
images.

Status
------

stable

Usage
-----

```shell
vagrant init nixbox/nixos --box-version 24.11
```

Also have a look at the accompanying nixos vagrant plugin:
<https://github.com/nix-community/vagrant-nixos-plugin>

Auto Vars File
--------------

### iso_checksums

The `nixos.auto.pkvars.hcl` file contains two defined variables that are
required to build a box. The packer template will dereference the iso checksum
from the `iso_checksums` variable. If a checksum does not exist for the version
and architecture you are trying to build, the packer build will fail. Be sure
to add the proper checksum for the ISO you would like to use to the
`iso_checksums` map, if it does not already exist, before building.

### version

Use the `version` variable to set the version of NixOS you want to build. By
convention, this is usually set to the latest stable version of NixOS.

Building the images
-------------------

First install [packer](http://packer.io) and
[virtualbox](https://www.virtualbox.org/).

Four packer builders are currently supported:

- BIOS
	- Virtualbox (`BUILDER=virtualbox-iso.virtualbox`)
	- qemu / libvirt (`BUILDER=qemu.qemu`)
	- VMware (`BUILDER=vmware-iso.vmware`)
	- Hyper-V (`BUILDER=hyperv-iso.hyperv`)
- UEFI
        - Virtualbox (`BUILDER=virtualbox-iso.virtualbox-efi`)
        - qemu / libvirt (`BUILDER=qemu.qemu-efi`)

Have a look at the different `make build` target to build your image.

```shell
make build-all # Build latest version for all architectures
make VERSION=24.11 build # Build specific version for x86_64 architecture
make VERSION=24.11 ARCH=i686 build # Build specific version for specific architecture

make vagrant-add
make vagrant-push
```

If you build on a host that does not support Makefile, here are some examples:

```shell
packer build --only=virtualbox-iso.virtualbox -var version=24.11 --except=vagrant-cloud nixos.pkr.hcl
packer build --only=qemu.qemu -var version=24.11 --except=vagrant-cloud nixos.pkr.hcl
packer build --only=vmware-iso.vmware -var version=24.11 --except=vagrant-cloud nixos.pkr.hcl
packer build --only=hyperv-iso.hyperv -var version=24.11 --except=vagrant-cloud nixos.pkr.hcl
```

The vagrant .box image is now ready to go and you can use it in vagrant:

```shell
vagrant box add nixbox32 nixos-24.11-libvirt-i686.box
# or
vagrant box add nixbox64 nixos-24.11-virtualbox-x86_64.box
```

Troubleshooting
---------------

- If you build on a Windows OS, please make sure you keep the unix file
  encoding of the generated configuration files (see [issue\#30](https://github.com/nix-community/nixbox/issues/30)

- Timeouts are a common issue for build failures. These can be a bit tough to
  figure out. increase the `boot_wait` value in `nixos.auto.pkvars.hcl` if you
  think timeouts may be the cause of your build failures.

Sample Vagrantfile
------------------

```ruby
Vagrant.configure("2") do |config|

  # Disable shared virtualbox mount path (not vboxsf installed on guest)
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # Use a suitable NixOS base. VM built with nixbox are tested to work with
  # this plugin.
  config.vm.box = "nixos-24.11"

  # Add the htop package
  config.vm.provision :nixos,
    run: 'always',
    expression: {
      environment: {
        systemPackages: [ :htop ]
      }
    }

end
```

License
-------

Copyright 2022 under the MIT
Copyright 2015 under the MIT
