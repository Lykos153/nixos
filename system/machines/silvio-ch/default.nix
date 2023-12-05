{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  booq.audio = "pipewire";
  booq.impermanence.enable = true;
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./vpn.nix
    ./virtualisation.nix
    ./sops.nix
    ./disko.nix
    ./docker.nix
  ];
}
