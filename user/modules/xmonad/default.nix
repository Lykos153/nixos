{ config, lib, nixosConfig, pkgs, ... }:
lib.mkIf (config.booq.gui.enable && config.booq.gui.xmonad.enable) {
  booq.gui.xorg.enable = true;
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [
            haskellPackages.taffybar
          ];
    config = ./xmonad.hs;
  };

  home.packages = with pkgs; [
  ];

  services.taffybar.enable = true;
}
