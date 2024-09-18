{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  booq.full.enable = true;
  booq.sops.enable = false;

  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./users.nix
    ./state-version.nix
  ];
}
