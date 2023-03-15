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
    libFiles = {
      "Tools.hs" = pkgs.writeText "Tools.hs" ''
         module Tools where
         dmenu = "${pkgs.rofi}/bin/rofi -show drun"
         terminal = "${pkgs.alacritty}/bin/alacritty"
         lock = "${pkgs.systemd}/bin/loginctl lock-session"
      '';
    };
  };

  home.packages = with pkgs; [
  ];

  services.taffybar.enable = true;
}
