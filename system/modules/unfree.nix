{
  lib,
  config,
  ...
}: {
  # from https://github.com/NixOS/nixpkgs/issues/197325#issuecomment-1579420085
  options = with lib; {
    nixpkgs.allowUnfreePackages = mkOption {
      type = with types; listOf str;
      default = [];
      example = ["steam" "steam-original"];
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowUnfreePackages;
  };
}
