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
  home.packages = with pkgs; [
    discord
    min-ed-launcher
    ed-odyssey-materials-helper
  ];
  booq.lib.allowUnfreePackages = ["discord"];
}
