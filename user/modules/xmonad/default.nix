{ config, lib, nixosConfig, pkgs, ... }:
let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = [ pkgs.shotgun pkgs.slop pkgs.coreutils pkgs.xclip pkgs.libnotify ];
    text = ''
      if [ "''${1-}" = "selection" ]; then
        area=$(slop -f '-i %i -g %g')
      else
        area=""
      fi
      dirname="$HOME/Bilder/Screenshots"
      mkdir -p "$dirname" || notify-send "Failed to create directory $dirname"
      filename="$dirname/$(date +'%Y-%m-%d-%H%M%S.png')"
      # shellcheck disable=SC2086
      shotgun $area - | tee "$filename" | xclip -t 'image/png' -selection clipboard && notify-send "Screenshot saved to $filename and copied to clipboard"
    '';
  };
in
lib.mkIf (config.booq.gui.enable && config.booq.gui.xmonad.enable) {
  booq.gui.xorg.enable = true;
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = hp: [
        hp.dbus
        hp.monad-logger
    ];
    config = ./xmonad.hs;
    libFiles = {
      "Tools.hs" = pkgs.writeText "Tools.hs" ''
         module Tools where
         dmenu = "${pkgs.rofi}/bin/rofi -show drun"
         terminal = "${pkgs.alacritty}/bin/alacritty"

         -- Screenshots
         screenshot_full = "${screenshot}/bin/screenshot"
         screenshot_selection = "${screenshot}/bin/screenshot selection"

         lock = "${pkgs.systemd}/bin/loginctl lock-session"
         clipboard = "${pkgs.clipmenu}/bin/clipmenu -b -i"
      '';
    };
  };

  home.packages = with pkgs; [
    screenshot
  ];

}
