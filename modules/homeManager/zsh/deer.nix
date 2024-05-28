{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.zsh;
in {
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      plugins = with pkgs; [
        {
          name = "deer";
          src = fetchFromGitHub {
            owner = "vifon";
            repo = "deer";
            rev = "da9b86e98d712f4feadfd96070ddb4c99bd29e29";
            sha256 = "sha256-WdQAejYoIcAMHSVAeqC+KPDRpSqlRRPNdeoGUe7HiFY=";
          };
          file = "deer";
        }
      ];
    };
  };
}
