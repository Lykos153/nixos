{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./services.nix
    ./users.nix
    ./cinnamon.nix
    ./gaming.nix
    ./amd.nix
  ];
  booq.sops.enable = false;
}
