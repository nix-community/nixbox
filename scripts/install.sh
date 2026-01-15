#!/bin/sh -e

export MACHINE_TYPE=$([ -d /sys/firmware/efi/efivars ] && echo "UEFI" || echo "Legacy")

DEVICE="/dev/vda"
echo "Using device: $DEVICE"

# checking that the disk is avalable
if [ ! -b "$DEVICE" ]; then
  echo "ERROR: Device $DEVICE not available, unable to install!"
  echo "Available block devices:"
  lsblk
  exit 1
fi

# Partition disk
if [ $MACHINE_TYPE == "Legacy" ];then
cat <<FDISK | fdisk $DEVICE
n




a
w

FDISK

elif [ $MACHINE_TYPE == "UEFI" ];then

parted $DEVICE -- mklabel gpt
parted $DEVICE -- mkpart root ext4 512MB 100%
parted $DEVICE -- mkpart ESP fat32 1MB 512MB
parted $DEVICE -- set 2 esp on
fi

# Create filesystem
if [ $MACHINE_TYPE == "Legacy" ];then

mkfs.ext4 -j -L nixos ${DEVICE}1

elif [ $MACHINE_TYPE == "UEFI" ];then

mkfs.fat -F 32 -n esp ${DEVICE}2
mkfs.ext4 -L nixos ${DEVICE}1

fi

# Mount filesystem
mount LABEL=nixos /mnt
if [ $MACHINE_TYPE == "UEFI" ];then
mkdir -p /mnt/boot/efi
if [ -e /dev/disk/by-label/esp ];then
mount /dev/disk/by-label/esp /mnt/boot/efi
else
mount ${DEVICE}2 /mnt/boot/efi
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
