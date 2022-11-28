{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # GTK themes.
  #See https://www.reddit.com/r/NixOS/comments/b255k5/home_manager_cannot_set_gnome_themes/
  programs.dconf.enable = true;

  services.tumbler.enable = true;
  # https://unix.stackexchange.com/questions/344402/how-to-unlock-gnome-keyring-automatically-in-nixos
  services.gnome.gnome-keyring.enable = true;

}
