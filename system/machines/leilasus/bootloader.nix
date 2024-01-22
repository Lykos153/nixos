{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      device = "nodev";
      efiSupport = true;
    };
  };
}
