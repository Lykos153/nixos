{config, lib, pkgs, modulesPath, ... }:
{
  booq.audio = "pipewire";
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./vpn.nix
  ];
}
