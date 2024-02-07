{pkgs, ...}: {
  # https://nixos.wiki/wiki/Printing
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [gutenprint gutenprintBin];
  #services.avahi.enable = true; # <- resulted in hangups on silvio-pc
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns4 = true;
}
