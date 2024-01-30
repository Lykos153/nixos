{config, ...}: {
  disko.devices = {
    disk.nvme-samsung = {
      device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB512HAJQ-000L7_S3TNNE0JC78861";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "2048";
            end = "2099199";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "luks";
            start = "2099200";
            end = "945817599";
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
                  "/@" = {
                    mountpoint = "${config.booq.impermanence.persistRoot}";
                    mountOptions = ["compress=zstd"];
                  };
                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd"];
                  };
                  "/@var-tmp" = {
                    mountpoint = "/var/tmp";
                    mountOptions = [
                      "mode=777"
                    ];
                  };
                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          }
          {
            name = "luks";
            start = "945817600";
            end = "100%";
            content = {
              type = "luks";
              name = "swap";
              extraOpenArgs = ["--allow-discards"];
              content = {
                type = "swap";
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
    nodev."/tmp" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=10G"
        "defaults"
        "mode=777"
      ];
    };
  };
  fileSystems."${config.booq.impermanence.persistRoot}".neededForBoot = true;
  boot.kernel.sysctl."vm.swappiness" = 0; # Use swap only for hibernate (SSD)
}
