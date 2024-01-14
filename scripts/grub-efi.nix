# This file is overwritten by the vagrant-nixos plugin
{ config, pkgs, ... }:
{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
    };
  # Use the GRUB 2 boot loader.
    grub = {
      enable = true;
      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };
  };
}
