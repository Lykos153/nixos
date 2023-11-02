{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  booq.audio = "pipewire";
  boot.initrd.systemd.enable = true;
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./vpn.nix
    ./virtualisation.nix
    ./sops.nix
    ./disko.nix
    ./impermanence.nix
    ./docker.nix
  ];
}
