{config, ...}: {
  disko.devices = {
    disk.nvme-adata = {
      device = "/dev/disk/by-id/nvme-ADATA_SX8200PNP_2J3820020714";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            # label = "ESP";
            type = "EF00";
            size = "550MiB";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=95%"
        "defaults"
        "mode=755"
      ];
    };

    nodev."/home" = {
      fsType = "auto";
      device = "/bcachefs/home";
      mountOptions = ["bind"];
    };
    nodev."/nix" = {
      fsType = "auto";
      device = "/bcachefs/nix";
      mountOptions = ["bind" "noatime"];
    };
  };
  # fileSystems."/btrfs".neededForBoot = true;
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "95%";
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";
}
