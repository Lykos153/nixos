{
  boot.initrd.systemd.enable = false;

  fileSystems."/nix" = {
    device = "UUID=cd4dcd1b-b8af-46e0-8af6-6288fd20c365";
    fsType = "bcachefs";
    options = ["compression=zstd"];
    neededForBoot = true;
  };
  specialisation.fsck.configuration.fileSystems."/nix".options = ["fsck" "fix_errors"];
}
