# This file is overwritten by the vagrant-nixos plugin
{ config, pkgs, ... }:
{
  imports = [
    ./vagrant-hostname.nix
    ./vagrant-network.nix
  ];
}
