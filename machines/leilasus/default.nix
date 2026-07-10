{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./services.nix
    ./users.nix
    ./cinnamon.nix
    ./amd.nix
    ./state-version.nix
    ./steam.nix
  ];
  booq.full.enable = true;
  booq.sops.enable = false;
  booq.gaming.enable = true;
  booq.audio.backend = "pipewire";
  booq.networking.networkmanager = true;
  environment.systemPackages = with pkgs; [
    ultrastardx
    proton-vpn-cli
    proton-vpn
  ];
}
