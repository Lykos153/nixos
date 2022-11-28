{ config, lib, pkgs, ... }:
let
  okular-x11 = pkgs.symlinkJoin {
    name = "okular";
    paths = [ pkgs.okular ];
    buildInputs = [ pkgs.makeWrapper ];
    # force okular to use xwayland, because of https://github.com/swaywm/sway/issues/4973
    postBuild = ''
      wrapProgram $out/bin/okular \
        --set QT_QPA_PLATFORM xcb
    '';
  };
in
{
  config = lib.mkIf config.booq.gui.enable {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.firefox-wayland;
      };
      chromium.enable = true;
    };

    home.packages = with pkgs; [
      termite
      gajim
      thunderbird
      schildichat-desktop
      pavucontrol
      libreoffice
      nomacs
      okular-x11
      xfce.thunar
      vlc
      system-config-printer
    ];

    services = {
      udiskie.enable = true;
      network-manager-applet.enable = true;
      blueman-applet.enable = true;
    };

    home.sessionVariables = lib.mkIf config.booq.gui.sway.enable {
      # MOZ_ENABLE_WAYLAND = "1"; not yet, because of https://github.com/swaywm/wlroots/issues/3189
    };
  };
}
