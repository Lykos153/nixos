{config, ...}: {
  disko.devices = {
    disk.ata-samsung-850-evo = {
      device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S21PNSAG425668F";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "1MiB";
            end = "550MiB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "luks";
            start = "550MiB";
            end = "100%";
            content = {
              type = "luks";
              name = "crypted";
              extraOpenArgs = ["--allow-discards"];
              # if you want to use the key for interactive login be sure there is no trailing newline
              # keyFile = "/dev/shm/secret.key";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "${config.booq.impermanence.persistRoot}";
                    mountOptions = ["compress=zstd"];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd"];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          }
        ];
      };
    };
    disk.nvme-adata = {
      device = "/dev/disk/by-id/nvme-ADATA_SX8200PNP_2J3820020714";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "1MiB";
            end = "550MiB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
            };
          }
          {
            name = "luks";
            start = "550MiB";
            end = "500GiB";
            content = {
              type = "luks";
              name = "crypted2";
              extraOpenArgs = ["--allow-discards"];
              content = {
                type = "btrfs";
              };
            };
          }
          {
            name = "luks";
            start = "500GiB";
            end = "600GiB";
            content = {
              type = "luks";
              name = "windows";
              extraOpenArgs = ["--allow-discards"];
              content = {
                type = "lvm_pv";
                vg = "windows";
              };
            };
          }
        ];
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=2G"
        "defaults"
        "mode=755"
      ];
    };
  };
  fileSystems."${config.booq.impermanence.persistRoot}".neededForBoot = true;
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "95%";
}
