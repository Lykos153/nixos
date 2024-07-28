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
    ./sops.nix
  ];
  booq.workstation.enable = true;
  booq.securityKeys.enable = true;
}
