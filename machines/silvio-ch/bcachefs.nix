{
  boot.initrd.systemd.enable = false;

  fileSystems."/nix" = {
    # https://github.com/koverstreet/bcachefs/issues/812#issuecomment-2642432386
    device = "/dev/disk/by-uuid/cd4dcd1b-b8af-46e0-8af6-6288fd20c365";
    fsType = "bcachefs";
    neededForBoot = true;
  };
  specialisation.fsck.configuration.fileSystems."/nix".options = ["fsck" "fix_errors"];
}
