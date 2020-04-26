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

Building the images
-------------------

First install [packer](http://packer.io) and
[virtualbox](https://www.virtualbox.org/).

Three packer builders are currently supported:
- Virtualbox
- qemu / libvirt
- VMware
- Hyper-V

Have a look at the different `make build` target to build your image.

If you build on a host that does not support Makefile, here are some examples:
```
packer build --only=virtualbox-iso nixos-i686.json
packer build --only=qemu nixos-x86_64.json
packer build --only=vmware-iso nixos-x86_64.json
packer build --only=hyperv-iso nixos-x86_64.json
```

The vagrant .box image is now ready to go and you can use it in vagrant:

```
vagrant box add nixbox32 packer_virtualbox-iso_virtualbox.box
# or
vagrant box add nixbox64 packer_virtualbox-iso_virtualbox.box
```

Updating the ISO urls
---------------------

To update the ISO urls to the latest release run: `make update`

Troubleshooting
-----------------

If you build on a Windows OS, please make sure you keep the unix file encoding of the generated configuration files
(see [issue \#30](https://github.com/nix-community/nixbox/issues/30)

License
-------

Copyright 2015 under the MIT
