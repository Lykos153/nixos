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
    impermanence.persistRoot = "/nix/persist";
    shared-repo.enable = true;
    audio.backend = "pipewire";
    local.openvpn-ch.enable = true;
    nix-ld.enable = true;

    gnome.enable = false;
    plasma.enable = true;
  };
  services.openvpn.servers.ch.autoStart = false;

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # performance
  boot.kernelParams = ["preempt=full"];
  services.system76-scheduler.enable = true;

  # TODO: luks+yubikey+secureboot https://www.reddit.com/r/NixOS/comments/xrgszw/comment/iqf1gps/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  zramSwap.enable = false;
  # TODO evaluate https://github.com/vrmiguel/bustd instead
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 2;
    freeSwapThreshold = 2;
    enableNotifications = true;
  };
  imports = [
    ./hardware-configuration.nix
    ./steam-library.nix
    ./disko.nix
    ./ddns
    ./bootloader.nix
    ./services.nix
    ./virtualisation.nix
    ./sops.nix
    ./bcachefs.nix
    ./footswitch.nix
    ./nullfs.nix
  ];
}
