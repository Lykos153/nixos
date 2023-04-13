{ config, pkgs, lib, ... }:
lib.mkIf (config.booq.gui.enable && config.booq.gui.xorg.enable) {
  let
    mainBar = builtins.readFile ./bar.ini;
  in
  {
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        pulseSupport = true;
      };
      config = ./config.ini;
      extraConfig = mainBar;
      script = ''
        for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
          MONITOR=$m polybar --reload main & disown
        done
      '';
    };
  }
}
