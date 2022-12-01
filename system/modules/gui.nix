{ pkgs, ... }:
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

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  services.xserver.displayManager.startx.enable = true;

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };
}
