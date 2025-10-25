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
      settings = {
        core = {
          pager = "delta";
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
        delta = {
          navigate = true;
          light = false;
        };
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
      };
    };

    home.packages = [
      pkgs.delta
    ];
  };
}
