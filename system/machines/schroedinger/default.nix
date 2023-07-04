{config, lib, pkgs, modulesPath, ... }:
{
  booq.sops.enable = false;

  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./users.nix
  ];
}
