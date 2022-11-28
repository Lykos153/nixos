{config, lib, pkgs, modulesPath, ... }:
{
  booq.audio = "pipewire";
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./services.nix
    ./virtualisation.nix
  ];
}
