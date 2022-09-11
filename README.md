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

```
vagrant init nixos/nixos-18.09-i686
# or
vagrant init nixos/nixos-18.09-x86_64
```

Also have a look at the accompanying nixos vagrant plugin:
https://github.com/nix-community/vagrant-nixos-plugin

Auto Vars File
--------------

## iso_checksums

The `nixos.auto.pkvars.hcl` file contains two defined variables that are
required to build a box. The packer template will dereference the iso checksum
from the `iso_checksums` variable. If a checksum does not exist for the version
and architecture you are trying to build, the packer build will fail. Be sure
to add the proper checksum for the ISO you would like to use to the
`iso_checksums` map, if it does not already exist, before building.

## version

Use the `version` variable to set the version of NixOS you want to build. By
convention, this is usually set to the latest stable version of NixOS.

Building the images
-------------------

First install [packer](http://packer.io) and
[virtualbox](https://www.virtualbox.org/).

Four packer builders are currently supported:
- Virtualbox
- qemu / libvirt
- VMware
- Hyper-V

Have a look at the different `make build` target to build your image.

If you build on a host that does not support Makefile, here are some examples:
```
packer build --only=virtualbox-iso.virtualbox -var version=22.05 nixos.pkr.hcl
packer build --only=qemu.qemu -var version=22.05 nixos.pkr.hcl
packer build --only=vmware-iso.vmware -var version=22.05 nixos.pkr.hcl
packer build -var-file="nixos.auto.pkvars.hcl" --only=hyperv-iso.hyperv nixos.pkr.hcl
```

The vagrant .box image is now ready to go and you can use it in vagrant:

```
vagrant box add nixbox32 nixos-22.05-libvirt-i686.box
# or
vagrant box add nixbox64 nixos-22.05-virtualbox-x86_64.box
```
Troubleshooting
-----------------

* If you build on a Windows OS, please make sure you keep the unix file
  encoding of the generated configuration files (see [issue\#30](https://github.com/nix-community/nixbox/issues/30)

* Timeouts are a common issue for build failures. These can be a bit tough to
  figure out. increase the `boot_wait` value in `nixos.auto.pkvars.hcl` if you
  think timeouts may be the cause of your build failures.

License
-------

Copyright 2022 under the MIT
Copyright 2015 under the MIT
