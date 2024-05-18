{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  booq.networking.enable = true;
  booq.dotool = {
    enable = true;
    users = ["silvio" "sa"];
  };
  booq.securityKeys.enable = true;

  # booq.audio = "pipewire";
  booq.gaming.enable = true;
  booq.impermanence.enable = true;
  # TODO: luks+yubikey+secureboot https://www.reddit.com/r/NixOS/comments/xrgszw/comment/iqf1gps/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  zramSwap.enable = true;
  # TODO evaluate https://github.com/vrmiguel/bustd instead
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 5;
    enableNotifications = true;
  };
  imports = [
    ./hardware-configuration.nix
    ./hdd.nix
    ./disko.nix
    ./bootloader.nix
    ./services.nix
    ./virtualisation.nix
    ./sops.nix
    ./vpn.nix
    ./docker.nix
  ];
}
