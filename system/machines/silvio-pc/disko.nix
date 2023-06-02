{
  disko.devices = {
    disk.ata-samsung-850-evo = {
      device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S21PNSAG425668F";
      type = "disk";
      content =  {
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
              extraOpenArgs = [ "--allow-discards" ];
              # if you want to use the key for interactive login be sure there is no trailing newline
              # keyFile = "/dev/shm/secret.key";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                  };
                  "/home" = {
                    mountOptions = [ "compress=zstd" ];
                  };
                  "/nix" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          }
        ];
      };
    };
  };
}
