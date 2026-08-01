{
  config,
  lib,
  pkgs,
  ...
}: let
  luksDev = {
    keyfile = "keyfile";
    swap = "swap";
    bcachefs-hdd1 = "bcachefs-hdd1";
    bcachefs-hdd2 = "bcachefs-hdd2";
  };
  bcachefsUuid = "072163b4-0c28-4200-a777-775ec5d7efb0";
  mkBcachefsMount = {subdir, ...} @ args:
    (lib.filterAttrs (n: _: n != "subdir") args)
    // {
      device = "UUID=${bcachefsUuid}";
      fsType = "bcachefs";
      options =
        [
          "X-mount.subdir=${subdir}"
        ]
        ++ (args.options or []);
    };
in {
  boot.initrd.luks.devices = {
    "${luksDev.bcachefs-hdd1}".device = "/dev/disk/by-partlabel/${luksDev.bcachefs-hdd1}";
    "${luksDev.bcachefs-hdd2}".device = "/dev/disk/by-partlabel/${luksDev.bcachefs-hdd2}";
    "${luksDev.swap}".device = "/dev/disk/by-uuid/ee12d6be-a7ba-4ebf-8fde-e8ce976ff1e4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E834-CB21";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/" = mkBcachefsMount {
    subdir = "persist";
  };
  fileSystems."/nix" = mkBcachefsMount {subdir = "nix";};
  fileSystems."/home" = mkBcachefsMount {subdir = "home";};

  swapDevices = [{device = "/dev/mapper/${luksDev.swap}";}];
  boot.resumeDevice = "/dev/mapper/${luksDev.swap}";

  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "95%";
}
