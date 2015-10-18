# This script is overwritten by vagrant. See
# https://github.com/mitchellh/vagrant/blob/master/templates/guests/nixos/hostname.erb
{ config, pkgs, ... }:
{
  networking.hostName = "nixbox";
}
