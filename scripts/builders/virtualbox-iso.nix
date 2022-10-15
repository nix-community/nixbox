{ lib, ... }:
{
  # Disable virtualbox guest additions. (it marked not working, and can't install on any NixOS version.)
  virtualisation.virtualbox.guest = lib.mkForce { enable = false; };

  # Add vboxsf group to the vagrant user
  # users.users.vagrant.extraGroups = [ "vboxsf" ];
}
