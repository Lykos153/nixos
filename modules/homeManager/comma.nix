{
  config,
  lib,
  ...
}: let
  cfg = config.booq.comma;
in {
  options.booq.comma = {
    enable = lib.mkEnableOption "comma";
  };
  config = lib.mkIf cfg.enable {
    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;
    home.shellAliases."," = "comma";
  };
}
