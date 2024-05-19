{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # booq.audio = "pipewire";
  booq.virtualisation = {
    enable = true;
    libvirtUsers = ["silvio" "sa"];
  };
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./vpn.nix
    ./sops.nix
    ./disko.nix
    ./docker.nix
    ./impermanence.nix
  ];
}
