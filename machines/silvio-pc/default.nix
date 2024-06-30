{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  booq = {
    full.enable = true;
    dotool.users = ["silvio" "sa"];
    securityKeys.enable = true;
    gaming.enable = true;
    impermanence.enable = true;
    shared-repo.enable = true;
    # audio.backend = "pipewire";
    local.openvpn-ch.enable = true;
  };

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
    ./docker.nix
    ./bcachefs.nix
  ];
}
