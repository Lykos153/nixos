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
    ./disks.nix
    ./sops.nix
    ./state-version.nix
    ./audio.nix
  ];
  booq.workstation.enable = true;
  booq.securityKeys.enable = true;
  booq.networking.networkmanager = true;
  booq.users.filterUsers = ["silvio"];
  booq.shared-repo.enable = true;
}
