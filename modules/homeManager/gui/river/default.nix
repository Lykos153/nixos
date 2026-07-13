{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.booq.gui.river;
  inherit (config.booq.gui.wayland) screenShotCommand lockCommand poweroffMenu;
in {
  imports = [./river-classic.nix];
  options.booq.gui.river.enable = lib.mkEnableOption "river";
  options.booq.gui.river.classic = lib.mkEnableOption "river-classic";
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
