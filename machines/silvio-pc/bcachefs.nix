{
  lib,
  pkgs,
  ...
}: {
  boot.initrd.systemd.enable = false;

  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.linux_6_11_rc5);

  fileSystems."/bcachefs" = {
    device = "UUID=677cf0a7-1abe-4ce3-876c-2ca63301229d";
    fsType = "bcachefs";
    options = ["compression=zstd"];
    neededForBoot = true;
  };
  specialisation.fsck.configuration.fileSystems."/bcachefs".options = ["fsck" "fix_errors"];
}
