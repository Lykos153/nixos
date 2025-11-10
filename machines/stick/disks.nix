{config, ...}: {
  booq.impermanence.enable = true;

  # boot.initrd.systemd.enable = false; # due to bcachefs

  boot.initrd.kernelModules = ["uas"]; # needed by SSK Port able
  booq.impermanence.persistRoot = "/_persist";
  fileSystems."${config.booq.impermanence.persistRoot}".neededForBoot = true;

  disko.devices = {
    disk.ssk-portable = {
      device = "/dev/disk/by-id/usb-SSK_Port_able_SSD_1TB_ABCDEFA92519-0:0";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "32G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          persist = {
            size = "600G";
            content = {
              type = "bcachefs";
              label = "ssk-portable";
              filesystem = "ssk-portable";
            };
          };
        };
      };
    };
    bcachefs_filesystems.ssk-portable = {
      type = "bcachefs_filesystem";
      extraFormatArgs = [
        "--compression=lz4"
        "--background_compression=lz4"
        "--encrypted"
      ];
      mountpoint = config.booq.impermanence.persistRoot;
      # TODO: use submodules instead of bind mounts here once it is fixed
      # https://github.com/nix-community/disko/issues/1045
    };
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=95%"
          "defaults"
          "mode=755"
        ];
      };
      "/nix" = {
        fsType = "none";
        device = "${config.booq.impermanence.persistRoot}/nix";
        mountOptions = ["bind" "noatime"];
      };
      "/home" = {
        fsType = "none";
        device = "${config.booq.impermanence.persistRoot}/home";
        mountOptions = ["bind"];
      };
    };
  };
}
