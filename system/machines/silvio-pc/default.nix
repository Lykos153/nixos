{config, lib, pkgs, modulesPath, ... }:
{
  booq.audio = "pipewire";
  imports = [
    ./hardware-configuration.nix
    ./old_btrfs.nix
    ./disko.nix
    ./bootloader.nix
    ./services.nix
    ./virtualisation.nix
    ./impermanence.nix
    ./sops.nix
  ];
}
