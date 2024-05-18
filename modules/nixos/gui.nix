{pkgs, ...}: {
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

  environment.pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw
  services.xserver.displayManager.startx.enable = true;

  services.libinput = {
    enable = true;

    touchpad = {
      naturalScrolling = true;
    };
  };

  services.xserver = {
    enable = true;

    # FIX for X Error of failed request: BadMatch (invalid parameter attributes)
    # when changing the layout via arandr/xrandr
    # https://www.reddit.com/r/NixOS/comments/v9r84l/issue_adding_new_mode_with_xrandr_badmatch/
    monitorSection = ''
      Modeline "1920x1080_143.98" 451.65 1920 2080 2296 2672 1080 1081 1084 1174 -HSync +Vsync
      Modeline "1280x960_143.98" 266.96 1280 1384 1528 1776 960 961 964 1044 -HSync +Vsync
    '';
    deviceSection = ''
      Option "ModeValidation" "AllowNonEdidModes"
    '';
    # ENDFIX

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
