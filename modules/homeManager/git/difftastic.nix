{
  config,
  lib,
  ...
}: let
  cfg = config.booq.git;
in {
  config = lib.mkIf cfg.enable {
    programs.difftastic.enable = true;
    programs.git.settings = {
      # diff.tool = "difftastic";
    };
  };
}
