#!/bin/sh

echo "Start postinstall ..."

# Cleanup any previous generations and delete old packages that can be
# pruned.

for x in $(seq 0 2) ; do
  nix-env --delete-generations old
  nix-collect-garbage -d
done


# Remove install ssh key
rm -rf /root/.ssh /root/.packer_http

# Zero out the disk (for better compression)
dd if=/dev/zero of=/EMPTY bs=1M
rm -rf /EMPTY
