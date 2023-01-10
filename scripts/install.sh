#!/bin/sh -e


# Partition disk
cat <<FDISK | fdisk /dev/sda
n




a
w

FDISK

# Create filesystem
mkfs.ext4 -j -L nixos /dev/sda1

# Mount filesystem
mount LABEL=nixos /mnt

# Setup system
nixos-generate-config --root /mnt

curl -sf "$PACKER_HTTP_ADDR/vagrant.nix" > /mnt/etc/nixos/vagrant.nix
curl -sf "$PACKER_HTTP_ADDR/vagrant-hostname.nix" > /mnt/etc/nixos/vagrant-hostname.nix
curl -sf "$PACKER_HTTP_ADDR/vagrant-network.nix" > /mnt/etc/nixos/vagrant-network.nix
curl -sf "$PACKER_HTTP_ADDR/builders/$PACKER_BUILDER_TYPE.nix" > /mnt/etc/nixos/hardware-builder.nix
curl -sf "$PACKER_HTTP_ADDR/configuration.nix" > /mnt/etc/nixos/configuration.nix
curl -sf "$PACKER_HTTP_ADDR/custom-configuration.nix" > /mnt/etc/nixos/custom-configuration.nix

### Install ###
nixos-install

### Cleanup ###
curl "$PACKER_HTTP_ADDR/postinstall.sh" | nixos-enter
