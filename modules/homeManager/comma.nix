{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.comma;
in {
  options.booq.comma = {
    enable = lib.mkEnableOption "comma";
  };
  config = lib.mkIf cfg.enable {
    booq.nix-index.enable = true;
    home.packages = [
      pkgs.comma
    ];
    home.shellAliases."," = "comma";
  };
}
