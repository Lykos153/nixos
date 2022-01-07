{
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      device = "/dev/disk/by-id/ata-WDC_WD3200AAKS-00UU3A0_WD-WCAYU3038785";
      efiSupport = true;
      efiInstallAsRemovable = true;
      useOSProber = true;
      default = "2";
    };
  };
}
