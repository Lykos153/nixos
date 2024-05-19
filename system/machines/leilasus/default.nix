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
    ./amd.nix
  ];
  booq.full.enable = true;
  booq.sops.enable = false;
  booq.gaming.enable = true;
}
