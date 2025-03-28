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
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "95%";
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";
  # fileSystems."/nix".neededForBoot = true;
  boot.kernel.sysctl."vm.swappiness" = 0; # Use swap only for hibernate (SSD)
}
