{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.jujutsu;
in {
  imports = [
  ];
  options.booq.jujutsu = {
    enable = lib.mkEnableOption "jujutsu";
  };
  config = lib.mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;
      settings = {
        ui.default-command = "log";
      };
    };

    home.packages = with pkgs; [
      lazyjj
    ];
  };
}
