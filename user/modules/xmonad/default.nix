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

         -- Screenshots
         -- TODO: Make derivation for screnshot scripts
         screenshot_dir = "$HOME/Bilder/Screenshots"
         screenshot_full = "export dirname=$HOME/Bilder/Screenshots; export filename=\"$dirname/$(date +'%Y-%m-%d-%H%M%S.png')\"; mkdir -p $dirname && ${pkgs.shotgun}/bin/shotgun - | ${pkgs.coreutils}/bin/tee $filename | ${pkgs.xclip}/bin/xclip -t 'image/png' -selection clipboard && ${pkgs.libnotify}/bin/notify-send \"Screenshot saved to $filename\""
         screenshot_selection = "export dirname=$HOME/Bilder/Screenshots; export filename=\"$dirname/$(date +'%Y-%m-%d-%H%M%S.png')\"; mkdir -p $dirname && ${pkgs.shotgun}/bin/shotgun $(${pkgs.slop}/bin/slop -f '-i %i -g %g') - | ${pkgs.coreutils}/bin/tee $filename | ${pkgs.xclip}/bin/xclip -t 'image/png' -selection clipboard && ${pkgs.libnotify}/bin/notify-send \"Screenshot saved to $filename\""

         lock = "${pkgs.systemd}/bin/loginctl lock-session"
         clipboard = "${pkgs.clipmenu}/bin/clipmenu -b -i"
      '';
    };
  };

  home.packages = with pkgs; [
  ];

  services.taffybar.enable = true;
}
