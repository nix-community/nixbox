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
vagrant init zimbatm/nixos-14.12-i686
# or
vagrant init zimbatm/nixos-14.12-x86_64
```

Also have a look at the nixos vagrant plugin:
https://github.com/oxdi/vagrant-nixos

Building the images
-------------------

First install [packer](http://packer.io) and
[virtualbox](https://www.virtualbox.org/)

Then:

```
packer build nixos-i686.json
# or
packer build nixos-x86_64.json
```

The .box image is now ready to go and you can use it in vagrant:

```
vagrant box add nixbox32 packer_virtualbox-iso_virtualbox.box
# or
vagrant box add nixbox64 packer_virtualbox-iso_virtualbox.box
```

License
-------

Copyright 2014 under the MIT

