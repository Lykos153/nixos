{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.booq.gui.mangowm;
in {
  options.booq.gui.mangowm.enable = lib.mkEnableOption "mangowm";
  config = lib.mkIf cfg.enable {
    wayland.windowManager.mango = {
      enable = true;
      package = pkgs.mango;
    };
    booq.gui.noctalia.enable = true;
    programs.noctalia.settings = {
      bar.default = {
        shadow = false;
        contact_shadow = false;
      };
      dock.shadow = false;
      shell.panel.shadow = false;
    };
    xdg.configFile = lib.mkIf (config.booq.mutableFlakeDir != null) {
      "mango".source = config.lib.file.mkOutOfStoreSymlink "${config.booq.mutableFlakeDir}/modules/homeManager/gui/mangowm/config";
    };
  };
}
