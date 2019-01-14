{ ... }:
{
  # Enable guest additions.
  virtualisation.virtualbox.guest.enable = true;

  # Add vboxsf group to the vagrant user
  users.users.vagrant.extraGroups = [ "vboxsf" ];
}
