{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  booq = {
    full.enable = true;
    securityKeys.enable = true;
    gaming.enable = true;
    impermanence.enable = true;
    impermanence.persistRoot = "/nix/persist";
    shared-repo.enable = true;
  };

  booq.networking.enable = lib.mkForce false;
  booq.users.enable = true;

  services.openssh.enable = true;

  programs.hyprland.enable = true;

  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ./ddns
    ./bootloader.nix
  ];
}
