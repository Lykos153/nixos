{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.booq.gui.river;
  inherit (config.booq.gui.wayland) screenShotCommand lockCommand poweroffMenu;
in {
  options.booq.gui.river.enable = lib.mkEnableOption "river";
  config = lib.mkIf cfg.enable {
    booq.gui.wayland.enable = true;
    home.packages = with pkgs; [
    ];
    wayland.windowManager.river = {
      enable = true;
      package = pkgs.river;
      extraConfig = ''
      '';
    };
  };
}
