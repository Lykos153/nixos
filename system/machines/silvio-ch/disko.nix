{config, ...}: {
  disko.devices = {
    disk.nvme-samsung = {
      device = "/dev/disk/by-id/nvme-SKHynix_HFS001TEJ4X113N_4SC8N51931OA08M50_1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            label = "ESP";
            size = "500";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          rootfs = {
            label = "rootfs";
            size = "200000";
            content = {
              type = "filesystem";
              format = "bcachefs";
              mountpoint = "/nix";
              # extraOpenArgs = ["-osubvol=nix"];
            };
          };
        };
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
  # fileSystems."/nix".neededForBoot = true;
  boot.kernel.sysctl."vm.swappiness" = 0; # Use swap only for hibernate (SSD)
}
