{config, lib, pkgs, modulesPath, ... }:
{
  booq.audio = "pipewire";
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./bootloader.nix
    ./services.nix
    ./virtualisation.nix
  ];
}
