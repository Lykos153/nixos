{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  booq.audio = "pipewire";
  # TODO: luks+yubikey+secureboot https://www.reddit.com/r/NixOS/comments/xrgszw/comment/iqf1gps/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
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
