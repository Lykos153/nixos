{config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./services.nix
    ./itsec-deps.nix
  ];
}
