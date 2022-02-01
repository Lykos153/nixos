{
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      device = "/dev/disk/by-id/ata-SanDisk_SDSSDA-1T00_20074D800780";
      efiSupport = true;
      efiInstallAsRemovable = true;
      useOSProber = true;
      default = "2";
    };
  };
}
