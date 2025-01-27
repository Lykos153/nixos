{pkgs, ...}: {
  programs.gnome-shell = {
    enable = true;
    theme = {
      name = "Plata-Noir";
      package = pkgs.plata-theme;
    };
  };
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
