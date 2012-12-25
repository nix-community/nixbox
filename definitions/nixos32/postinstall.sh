#!/bin/sh

# Remove VirtualBox Guest Additions ISO that the Veewee put in our
# home dir

rm -f ~/*.iso

# Install chef & puppet

su - vagrant -c 'gem install chef puppet --user-install \
  --bindir=$HOME/bin --no-rdoc --no-ri'

# ***TEMPORARILY*** clone Tim Dysinger's nixos repos to get VirtualBox
# Guest Additions working correctly.

git clone --depth=1 --branch=develop \
    git://github.com/dysinger/nixos.git \
    /etc/nixos/nixos

git clone --depth=1 --branch=develop \
    git://github.com/dysinger/nixpkgs.git \
    /etc/nixos/nixpkgs

# ***TEMPORARILY*** Rebuild with the lastest (now working) VirtualBox
# 4.2.6 Guest Additions from the develop branch @ our git repo in
# /etc/nixos/nixpkgs

export NIX_PATH=\
nixos-config=/etc/nixos/configuration.nix:\
nixos=/etc/nixos/nixos:\
nixpkgs=/etc/nixos/nixpkgs:\
services=/etc/nixos/services

nixos-rebuild --upgrade switch

# Cleanup any previous generations and delete old packages that can be
# pruned.

for x in `seq 0 6` ; do
    nix-env --delete-generations old
    nix-collect-garbage -d
done

# Zero out the disk (for better compression)

dd if=/dev/zero of=/EMPTY bs=1M
rm -rf /EMPTY
