{ config, lib, ... }:
#TODO: If pipewire
lib.mkIf (config.booq.gui.enable && config.booq.gui.sway.enable) {
  # screen recording/sharing with pipewire
  # portal is installed in system configuration
  xdg.configFile."xdg-desktop-portal-wlr/config".text = lib.generators.toINI { } {
    screencast = {
      max_fps = 30;
      chooser_type = "simple";
      chooser_cmd = "slurp -f %o -or";
    };
  };
}
