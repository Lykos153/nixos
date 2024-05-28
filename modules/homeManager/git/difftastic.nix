{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.booq.git;
in {
  config = lib.mkIf cfg.enable {
    programs.git = {
      difftastic.enable = true;
      extraConfig = {
        # diff.tool = "difftastic";
      };
    };

    home.packages = [
      pkgs.difftastic
    ];
  };
}
