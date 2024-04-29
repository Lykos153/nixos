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
          crypted = {
            size = "500GiB";
            content = {
              type = "luks";
              name = "crypted";
              extraOpenArgs = ["--allow-discards"];
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
          };
          windows = {
            size = "100GiB";
            content = {
              type = "luks";
              name = "windows";
              extraOpenArgs = ["--allow-discards"];
              content = {
                type = "lvm_pv";
                vg = "windows";
              };
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
  };
  fileSystems."${config.booq.impermanence.persistRoot}".neededForBoot = true;
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "95%";
}
