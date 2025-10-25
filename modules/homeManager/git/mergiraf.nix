{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.git;
in {
  config = lib.mkIf cfg.enable {
    programs.git = {
      settings = {
        merge.mergiraf = {
          name = "mergiraf";
          driver = "${pkgs.mergiraf}/bin/mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P";
        };
      };

      # or generate the list with runCommand and `mergiraf languages --gitattributes` so it stays up-to-date
      attributes = [
        "*.java merge=mergiraf"
        "*.rs merge=mergiraf"
        "*.go merge=mergiraf"
        "*.js merge=mergiraf"
        "*.jsx merge=mergiraf"
        "*.json merge=mergiraf"
        "*.yml merge=mergiraf"
        "*.yaml merge=mergiraf"
        "*.html merge=mergiraf"
        "*.htm merge=mergiraf"
        "*.xhtml merge=mergiraf"
        "*.xml merge=mergiraf"
        "*.c merge=mergiraf"
        "*.cc merge=mergiraf"
        "*.h merge=mergiraf"
        "*.cpp merge=mergiraf"
        "*.hpp merge=mergiraf"
        "*.cs merge=mergiraf"
        "*.dart merge=mergiraf"
      ];
    };

    home.packages = with pkgs; [
      mergiraf
    ];
  };
}
