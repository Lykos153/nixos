{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.booq.gui.noctalia;
in {
  options.booq.gui.noctalia.enable = lib.mkEnableOption "noctalia";
  config = lib.mkIf cfg.enable {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      settings = {
        bar.default = {
          center = [
          ];
          end = [
            "media"
            "tray"
            "notifications"
            "clipboard"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "control-center"
            "session"
            "clock"
          ];
          position = "top";
          thickness = 25;
          monitor."Samsung Electric Company C49J89x HNTR600175".margin_ends = "33%";
          monitor."eDP-1".position = "bottom";
        };
        nightlight.enabled = true;
        shell.clipboard_auto_paste = "off";
      };
    };
    services = {
      network-manager-applet.enable = lib.mkForce false;
      blueman-applet.enable = lib.mkForce false;
      pasystray.enable = lib.mkForce false;
      gammastep.enable = lib.mkForce false;
      cbatticon.enable = lib.mkForce false;
    };
  };
}
