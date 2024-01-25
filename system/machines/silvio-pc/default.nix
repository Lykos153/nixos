{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  booq.audio = "pipewire";
  booq.gaming.enable = true;
  booq.impermanence.enable = true;
  # TODO: luks+yubikey+secureboot https://www.reddit.com/r/NixOS/comments/xrgszw/comment/iqf1gps/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  zramSwap.enable = true;
  boot.supportedFilesystems = ["bcachefs"];
  imports = [
    ./hardware-configuration.nix
    ./hdd.nix
    ./disko.nix
    ./bootloader.nix
    ./services.nix
    ./virtualisation.nix
    ./sops.nix
    ./vpn.nix
    ./bcachefs.nix
  ];
}
