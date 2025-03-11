{
  config,
  lib,
  pkgs,
  ...
}: {
  options.booq.gui.enable = lib.mkEnableOption "gui";
  config = lib.mkIf config.booq.gui.enable {
    programs = {
      chromium.enable = true;
    };

    gtk = {
      enable = true;
      theme = lib.mkDefault {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
      iconTheme = {
        name = "Numix";
        package = pkgs.numix-icon-theme;
      };
    };

    services = {
      udiskie.enable = true;
      network-manager-applet.enable = true;
      blueman-applet.enable = true;
      pasystray.enable = true;
    };

    home.sessionVariables = lib.mkIf config.booq.gui.sway.enable {
      # MOZ_ENABLE_WAYLAND = "1"; not yet, because of https://github.com/swaywm/wlroots/issues/3189
    };
  };
}
