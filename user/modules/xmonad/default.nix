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

  toggle-mute = pkgs.writeShellApplication {
    name = "toggle-mute";
    runtimeInputs = [ pkgs.pulseaudio pkgs.gawk ];
    text = ''
      mute_unmute () {
        pactl list short sources | awk '/input.*RUNNING/ {system("pactl set-source-mute " $1 " '"$1"'")}'
      }
      unmute_all () { mute_unmute 0; }
      mute_all () { mute_unmute 1; }
      mutefile="/run/user/$(id -u)/global-mute"
      if [ -e "$mutefile" ]; then
        unmute_all
        if which mumctl &> /dev/null; then mumctl unmute; fi
        rm "$mutefile"
      else
        if which mumctl &> /dev/null; then mumctl mute; fi
        mute_all
        touch "$mutefile"
      fi
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

         -- PTT
         toggle_mute = "${toggle-mute}/bin/toggle-mute";
      '';
    };
  };

  home.packages = with pkgs; [
    screenshot
    toggle-mute
  ];

}
