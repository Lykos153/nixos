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
    ./disks.nix
    ./state-version.nix
  ];
  booq.workstation.enable = true;
  booq.securityKeys.enable = true;

  # fileSystems."/btrfs".neededForBoot = true;
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "95%";
}
