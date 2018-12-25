{ modulesPath, ... }:
{
  imports = [
    "${toString modulesPath}/profiles/qemu-guest.nix"
  ];
}
