{ config, pkgs, ... }:

{
  # Enable guest additions.
  virtualisation.hypervGuest.enable = true;

  # Enable systemd efi bootloader
  boot.loader.systemd-boot.enable   = true;

  environment.systemPackages = with pkgs; [
    cifs-utils
  ];
}