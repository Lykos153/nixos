{ config, lib, pkgs, modulesPath, ... }:

{
  boot.initrd.kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
  boot.initrd.luks.yubikeySupport = true;
  boot.initrd.luks.devices."arch-root" = {
    device = "/dev/disk/by-uuid/b474463d-7d93-4abf-95cd-35db2f9a6490";
    yubikey = {
      slot = 2;
      twoFactor = true; # Set to false for 1FA
      gracePeriod = 30; # Time in seconds to wait for Yubikey to be inserted
      keyLength = 64; # Set to $KEY_LENGTH/8
      saltLength = 16; # Set to $SALT_LENGTH

      storage = {
        device = "/dev/nvme1n1p1"; # Be sure to update this to the correct volume
        fsType = "vfat";
        path = "/crypt-storage/default";
      };
    };
  };

  boot.initrd.luks.devices."arch-root2" = {
    device = "/dev/disk/by-uuid/efae7e7f-5c77-4957-9a75-f2862e620d15";
    yubikey = {
      slot = 2;
      twoFactor = true; # Set to false for 1FA
      gracePeriod = 30; # Time in seconds to wait for Yubikey to be inserted
      keyLength = 64; # Set to $KEY_LENGTH/8
      saltLength = 16; # Set to $SALT_LENGTH

      storage = {
        device = "/dev/nvme1n1p1"; # Be sure to update this to the correct volume
        fsType = "vfat";
        path = "/crypt-storage/default";
      };
    };
  };

  boot.initrd.luks.devices."arch-root3" = {
    device = "/dev/disk/by-uuid/d55b7110-02b2-47fd-9441-bf53c67eeccc";
    yubikey = {
      slot = 2;
      twoFactor = true; # Set to false for 1FA
      gracePeriod = 30; # Time in seconds to wait for Yubikey to be inserted
      keyLength = 64; # Set to $KEY_LENGTH/8
      saltLength = 16; # Set to $SALT_LENGTH

      storage = {
        device = "/dev/nvme1n1p1"; # Be sure to update this to the correct volume
        fsType = "vfat";
        path = "/crypt-storage/default";
      };
    };
  };
}
