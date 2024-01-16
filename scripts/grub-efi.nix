# This file is overwritten by the vagrant-nixos plugin
{ config, pkgs, ... }:
{
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot/efi";
    };
  # Use the GRUB 2 boot loader.
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      efiInstallAsRemovable = true;
    };
  };
}
