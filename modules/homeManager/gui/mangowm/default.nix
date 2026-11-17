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
    };
    xdg.configFile = lib.mkIf (config.booq.mutableFlakeDir != null) {
      "mango".source = config.lib.file.mkOutOfStoreSymlink "${config.booq.mutableFlakeDir}/modules/homeManager/gui/mangowm/config";
    };
  };
}
