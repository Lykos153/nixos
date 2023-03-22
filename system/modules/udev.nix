{
  services.udev.extraRules = ''
    # permissions for pkgs.footpedal to access pcsensor footpedal.
    # TODO: make this a derivation to be added to udev.packages?
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0c45", ATTRS{idProduct}=="7403|7404", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="413d", ATTRS{idProduct}=="2107", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="e026", MODE="0666"
  '';
}
