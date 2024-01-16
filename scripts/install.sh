#!/bin/sh -e

export MACHINE_TYPE=$([ -d /sys/firmware/efi/efivars ] && echo "UEFI" || echo "Legacy")

# Partition disk
if [ $MACHINE_TYPE == "Legacy" ];then
cat <<FDISK | fdisk /dev/sda
n




a
w

FDISK

elif [ $MACHINE_TYPE == "UEFI" ];then

parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart root ext4 512MB 100%
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 2 esp on
fi

# Create filesystem
if [ $MACHINE_TYPE == "Legacy" ];then

mkfs.ext4 -j -L nixos /dev/sda1

elif [ $MACHINE_TYPE == "UEFI" ];then

mkfs.fat -F 32 -n esp /dev/sda2
mkfs.ext4 -L nixos /dev/sda1

fi

# Mount filesystem
mount LABEL=nixos /mnt
if [ $MACHINE_TYPE == "UEFI" ];then
mkdir -p /mnt/boot/efi
if [ -e /dev/disk/by-label/esp ];then
mount /dev/disk/by-label/esp /mnt/boot/efi
else
mount /dev/sda2 /mnt/boot/efi
fi
fi

# Setup system
nixos-generate-config --root /mnt

curl -sf "$PACKER_HTTP_ADDR/vagrant.nix" > /mnt/etc/nixos/vagrant.nix
if [ $MACHINE_TYPE == "Legacy" ];then
curl -sf "$PACKER_HTTP_ADDR/grub-bios.nix" > /mnt/etc/nixos/bootloader.nix
elif [ $MACHINE_TYPE == "UEFI" ];then
curl -sf "$PACKER_HTTP_ADDR/grub-efi.nix" > /mnt/etc/nixos/bootloader.nix
fi
curl -sf "$PACKER_HTTP_ADDR/vagrant-hostname.nix" > /mnt/etc/nixos/vagrant-hostname.nix
curl -sf "$PACKER_HTTP_ADDR/vagrant-network.nix" > /mnt/etc/nixos/vagrant-network.nix
curl -sf "$PACKER_HTTP_ADDR/builders/$PACKER_BUILDER_TYPE.nix" > /mnt/etc/nixos/hardware-builder.nix
curl -sf "$PACKER_HTTP_ADDR/configuration.nix" > /mnt/etc/nixos/configuration.nix
curl -sf "$PACKER_HTTP_ADDR/custom-configuration.nix" > /mnt/etc/nixos/custom-configuration.nix

### Install ###
nixos-install

### Cleanup ###
curl "$PACKER_HTTP_ADDR/postinstall.sh" | nixos-enter
