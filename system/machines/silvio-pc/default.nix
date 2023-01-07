{config, lib, pkgs, modulesPath, ... }:
{
  booq.audio = "pipewire";
  imports = [
    ./hardware-configuration.nix
    ./luks.nix
    ./bootloader.nix
    ./services.nix
    ./virtualisation.nix
  ];
}
