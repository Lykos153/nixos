{
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };
}
