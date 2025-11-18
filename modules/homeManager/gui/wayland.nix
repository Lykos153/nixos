{
  config,
  lib,
  pkgs,
  ...
}: let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [
      sway-contrib.grimshot
      libnotify
    ];
    text = ''
      screenshot_dir="$HOME/Bilder/Screenshots"
      action=''${1:-screen}

      mkdir -p "$screenshot_dir"
      result="$(grimshot save "$action" "$screenshot_dir/$(date +'%Y-%m-%d-%H%M%S.png')")"
      notify-send "$result"
    '';
  };
  poweroffMenu = pkgs.writeScript "poweroff-menu" ''
    while [ "$select" != "NO" ] && [ "$select" != "YES" ]; do
        select=$(echo -e 'NO\nYES' | ${pkgs.bemenu}/bin/bemenu --nb '#151515' --nf '#999999' --sb '#f00060' --sf '#000000' --fn '-*-*-medium-r-normal-*-*-*-*-*-*-100-*-*' -i -p "Poweroff?" -w)
        [ -z "$select" ] && exit 0
    done
    [ "$select" = "NO" ] && exit 0
    poweroff
  '';
in {
  options.booq.gui.wayland = {
    enable = lib.mkEnableOption "Wayland";
    screenShotCommand = lib.mkOption {
      internal = true;
      default = screenshot;
    };
    lockCommand = lib.mkOption {
      internal = true;
      default = pkgs.writeScript "lockcmd" ''
        ${pkgs.swaylock}/bin/swaylock -f -c000000
      '';
    };
    poweroffMenu = lib.mkOption {
      internal = true;
      default = poweroffMenu;
    };
  };
  config = lib.mkIf config.booq.gui.wayland.enable {
    services.kanshi.enable = true;
    services.clipman.enable = true;
    home.packages = with pkgs; [
      wdisplays
      wlr-randr
      wl-clipboard
      screenshot
    ];
  };
}
