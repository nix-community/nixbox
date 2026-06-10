# This file is overwritten by the vagrant-nixos plugin
{ config, pkgs, ... }:
{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
}
