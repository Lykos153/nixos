{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.nixpkgs.allowUnfreePackages;
in {
  options = {
    nixpkgs.allowUnfreePackages = mkOption {
      default = [];
      type = types.listOf types.str;
      description = "List of unfree packages allowed to be installed";
      example = lib.literalExpression ''[ "slack" "discord" steam-.*" ]'';
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg: let
      pkgName = lib.getName pkg;
      matchPkgs = reg: ! builtins.isNull (builtins.match reg pkgName);
    in
      builtins.any matchPkgs cfg;
  };
}
