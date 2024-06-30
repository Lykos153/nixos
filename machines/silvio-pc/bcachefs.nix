{
  boot.initrd.systemd.enable = false;

  fileSystems."/bcachefs" = {
    device = "UUID=677cf0a7-1abe-4ce3-876c-2ca63301229d";
    fsType = "bcachefs";
    options = ["compression=zstd"];
    neededForBoot = true;
  };
}
