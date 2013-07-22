NixOS boxes for Vagrant
=======================

First install packer: http://packer.io (or `brew install packer`)

Then:

```
packer build --only=virtualbox nixos32-template.json
```
