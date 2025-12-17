# from https://lix.systems/add-to-config/
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.booq.lix;
in {
  options.booq.lix.enable = lib.mkEnableOption "lix";
  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        my-new-package = prev.my-new-package.override {
          nix = final.lixPackageSets.stable.lix;
        }; # Adapt to your specific use case.

        inherit
          (final.lixPackageSets.stable)
          nixpkgs-review
          nix-direnv
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ];

    nix.package = pkgs.lixPackageSets.stable.lix;
  };
}
