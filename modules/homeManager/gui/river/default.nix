{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.booq.gui.river;
  inherit (config.booq.gui.wayland) screenShotCommand lockCommand poweroffMenu;
in {
  options.booq.gui.river.enable = lib.mkEnableOption "river";
  config = lib.mkIf cfg.enable {
    booq.gui.wayland.enable = true;
    home.packages = let
      river-pkgs = inputs.nixpkgs-river.legacyPackages.${config.nixpkgs.hostPlatform.system};
    in [
      river-pkgs.kwim
      (river-pkgs.kwm.overrideAttrs (prev: {
        patches =
          (prev.patches or [])
          ++ [
            (pkgs.fetchpatch {
              url = "https://github.com/kewuaa/kwm/commit/65accc9480de584006aa29394fafffd879b515b9.patch";
              hash = "sha256-vioOAm7/METWe13mxCdHyEh1+Gjk4dNEERCCJoZbXI4=";
            })
          ];
      }))
    ];
    wayland.windowManager.river = {
      enable = true;
      package = pkgs.river;
      extraConfig = ''
        exec kwm &> $HOME/.kwm.log
      '';
    };
    xdg.configFile."kwm/config.zon".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/homeManager/gui/river/kwm.config.zon";
    xdg.configFile."kwim/config.zon".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/homeManager/gui/river/kwim.config.zon";
  };
}
