#!/bin/sh

echo "Start postinstall ..."

# Cleanup any previous generations and delete old packages that can be
# pruned.

for x in $(seq 0 2) ; do
  nix-env --delete-generations old
  nix-collect-garbage -d
done


if [[ "${PACKER_BUILDER_TYPE}" == "qemu" ]] ; then
  echo "skipping disk zero out!"
else
  echo "zeroing out the disk..."

  # Zero out the disk (for better compression)
  dd if=/dev/zero of=/EMPTY bs=1M
  rm -rf /EMPTY
fi
