{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  booq.full.enable = true;
  booq.securityKeys.enable = true;
  # booq.audio = "pipewire";
  booq.impermanence.enable = true;
  booq.shared-repo.enable = true;
  booq.gaming.enable = true;
  booq.virtualisation = {
    enable = true;
    libvirtUsers = ["silvio" "sa"];
  };
  booq.local.openvpn-ch = {
    enable = true;
    routes = "per-ip";
  };
  zramSwap.enable = false;
  # TODO evaluate https://github.com/vrmiguel/bustd instead
  services.earlyoom = {
    enable = false;
    freeMemThreshold = 5;
    freeSwapThreshold = 5;
    enableNotifications = true;
  };
  virtualisation.multipass.enable = true;
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./ddns
    ./sops.nix
    ./disko.nix
    ./bcachefs.nix
    ./docker.nix
    ./impermanence.nix
  ];
}
