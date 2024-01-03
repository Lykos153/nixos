{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = [pkgs.shotgun pkgs.slop pkgs.coreutils pkgs.xclip pkgs.libnotify];
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
    runtimeInputs = [pkgs.pulseaudio pkgs.gawk];
    text = ''
      mute_unmute () {
        pactl list short sources | awk '/input.*/ {system("pactl set-source-mute " $1 " '"$1"'")}'
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
in {
  options.booq.gui.xmonad.enable = lib.mkEnableOption "xmonad";
  config = lib.mkIf (config.booq.gui.enable && config.booq.gui.xmonad.enable) {
    booq.gui.xorg.enable = true;
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = false;
      extraPackages = let
        h = pkgs.haskellPackages.extend (self: super: {
          xmonad-contrib = self.callCabal2nix "xmonad-contrib" (pkgs.fetchFromGitHub {
            owner = "xmonad";
            repo = "xmonad-contrib";
            rev = "99b24f314b3ef86a3db6ac1cd786ac48a1db4147";
            sha256 = "sha256-ph1c+ztipvGpN1HtxZU4Qqw5MNTxbIDaB++poxOU5rw=";
          }) {};
        });
      in
        hp: [
          h.xmonad-contrib
          hp.xmonad-extras
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

          rofi_bluetooth = "${pkgs.rofi-bluetooth}/bin/rofi-bluetooth -i";
          rofi_pass = "${pkgs.rofi-pass}/bin/rofi-pass";
        '';
      };
    };

    home.packages = with pkgs; [
      screenshot
      toggle-mute
    ];
  };
}
