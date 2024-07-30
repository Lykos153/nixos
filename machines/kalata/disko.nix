{
  # lvm options
  boot.initrd.kernelModules = [
    "dm-snapshot" # when you are using snapshots
    "dm-raid" # e.g. when you are configuring raid1 via: `lvconvert -m1 /dev/pool/home`
    "dm-cache-default" # when using volumes set up with lvmcache
  ];

  boot.initrd.services.lvm.enable = true; 
  services.lvm.boot.thin.enable = true; # when using thin provisioning or caching

  disko.devices = {
    disk.ata-ssd-root = {
      device = "/dev/disk/by-id/ata-TS256GSSD230S_E681330952";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=700"];
            };
          };
          primary = {
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "mainpool";
            };
          };
        };
      };
    };
    
    lvm_vg = {
      mainpool = {
        type = "lvm_vg";
        lvs = {
          thinpool = {
            size = "50G";
            lvm_type = "thin-pool";
          };
          nix = {
            size = "50G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = [
                "defaults"
              ];
            };
          };
          home = {
            size = "50G";
            lvm_type = "thinlv";
            pool = "thinpool";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
            };
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=24G"
        "defaults"
        "mode=755"
      ];
    };
  };
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "24G";
}
