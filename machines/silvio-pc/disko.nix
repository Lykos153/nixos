{config, ...}: {
  disko.devices = {
    # disk.ata-samsung-850-evo = {
    #   device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S21PNSAG425668F";
    #   type = "disk";
    #   content = {
    #     type = "gpt";
    #     partitions = {
    #       windows = {
    #         size = "100%";
    #         content = {
    #           type = "luks";
    #           name = "windows-850-evo";
    #           extraOpenArgs = ["--allow-discards"];
    #           content = {
    #             type = "lvm_pv";
    #             vg = "windows";
    #           };
    #         };
    #       };
    #     };
    #   };
    # };
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
          # windows = {
          #   size = "100GiB";
          #   content = {
          #     type = "luks";
          #     name = "windows";
          #     extraOpenArgs = ["--allow-discards"];
          #     content = {
          #       type = "lvm_pv";
          #       vg = "windows";
          #     };
          #   };
          # };
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
}
