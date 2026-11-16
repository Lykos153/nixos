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
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };
  };
}
