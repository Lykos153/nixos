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
  booq.virtualisation = {
    enable = true;
    libvirtUsers = ["silvio" "sa"];
  };
  booq.local.openvpn-ch.enable = true;
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./sops.nix
    ./disko.nix
    ./docker.nix
    ./impermanence.nix
  ];
}
