{
  lib,
  config,
  ...
}: {
  environment.etc.crypttab = {
    enable = true;
    text = ''
      hdd1 /dev/disk/by-uuid/f37a1753-4514-49b1-90a2-235bd1306670 ${config.booq.impermanence.persistRoot}/passwords/luks_hdd luks,nofail
    '';
  };
  fileSystems."/hdd" = {
    device = "/dev/mapper/hdd1";
    fsType = "btrfs";
    options = ["subvol=/media" "x-systemd.automount"];
  };
}
