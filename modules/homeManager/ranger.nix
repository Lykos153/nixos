{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.ranger;
in {
  options.booq.ranger = {
    enable = lib.mkEnableOption "ranger";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ranger
    ];

    xdg.configFile."ranger/rc.conf".text = ''
      set mouse_enabled false
      alias git shell gitui
      map gg shell gitui
    '';

    home.shellAliases = {
      r = "ranger";
    };
  };
}
