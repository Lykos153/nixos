# More inspiration: https://git.sbruder.de/simon/nixos-config/src/branch/master/users/simon/modules/sway/default.nix
{ config, lib, nixosConfig, pkgs, ... }:
let
  cfg = config.wayland.windowManager.sway.config;
  lock = "${pkgs.swaylock}/bin/swaylock -f -c000000";
in
{  
  imports = [
    ./kanshi.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";

      menu = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --usage-log=$HOME/.cache/j4-dmenu-desktop.log --no-exec --dmenu=\"${pkgs.dmenu-wayland}/bin/dmenu-wl -i -nb '#002b36' -nf '#839496' -sb '#859900' -sf '#073642'\" | ${pkgs.findutils}/bin/xargs swaymsg exec --";

      left = "j";
      right = "odiaeresis";
      up = "l";
      down = "k";

      input = {
        "*" = {
          xkb_layout = "de";
        };
      };

      keybindings = {
        # Basics
        "${cfg.modifier}+Return" = "exec ${cfg.terminal}";
        "${cfg.modifier}+d" = "exec ${cfg.menu}";
        "${cfg.modifier}+Shift+q" = "kill";
        "${cfg.modifier}+Shift+r" = "reload";
        "${cfg.modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        # Focus
        "${cfg.modifier}+${cfg.left}" = "focus left";
        "${cfg.modifier}+${cfg.down}" = "focus down";
        "${cfg.modifier}+${cfg.up}" = "focus up";
        "${cfg.modifier}+${cfg.right}" = "focus right";

        "${cfg.modifier}+Left" = "focus left";
        "${cfg.modifier}+Down" = "focus down";
        "${cfg.modifier}+Up" = "focus up";
        "${cfg.modifier}+Right" = "focus right";

        # Moving
        "${cfg.modifier}+Shift+${cfg.left}" = "move left";
        "${cfg.modifier}+Shift+${cfg.down}" = "move down";
        "${cfg.modifier}+Shift+${cfg.up}" = "move up";
        "${cfg.modifier}+Shift+${cfg.right}" = "move right";

        "${cfg.modifier}+Shift+Left" = "move left";
        "${cfg.modifier}+Shift+Down" = "move down";
        "${cfg.modifier}+Shift+Up" = "move up";
        "${cfg.modifier}+Shift+Right" = "move right";

        # Workspaces
        "${cfg.modifier}+1" = "workspace number 1";
        "${cfg.modifier}+2" = "workspace number 2";
        "${cfg.modifier}+3" = "workspace number 3";
        "${cfg.modifier}+4" = "workspace number 4";
        "${cfg.modifier}+5" = "workspace number 5";
        "${cfg.modifier}+6" = "workspace number 6";
        "${cfg.modifier}+7" = "workspace number 7";
        "${cfg.modifier}+8" = "workspace number 8";
        "${cfg.modifier}+9" = "workspace number 9";
        "${cfg.modifier}+0" = "workspace number 10";

        "${cfg.modifier}+Shift+1" = "move container to workspace number 1";
        "${cfg.modifier}+Shift+2" = "move container to workspace number 2";
        "${cfg.modifier}+Shift+3" = "move container to workspace number 3";
        "${cfg.modifier}+Shift+4" = "move container to workspace number 4";
        "${cfg.modifier}+Shift+5" = "move container to workspace number 5";
        "${cfg.modifier}+Shift+6" = "move container to workspace number 6";
        "${cfg.modifier}+Shift+7" = "move container to workspace number 7";
        "${cfg.modifier}+Shift+8" = "move container to workspace number 8";
        "${cfg.modifier}+Shift+9" = "move container to workspace number 9";
        "${cfg.modifier}+Shift+0" = "move container to workspace number 10";

        # Moving workspaces between outputs
        "${cfg.modifier}+Control+${cfg.left}" = "move workspace to output left";
        "${cfg.modifier}+Control+${cfg.down}" = "move workspace to output down";
        "${cfg.modifier}+Control+${cfg.up}" = "move workspace to output up";
        "${cfg.modifier}+Control+${cfg.right}" = "move workspace to output right";

        "${cfg.modifier}+Control+Left" = "move workspace to output left";
        "${cfg.modifier}+Control+Down" = "move workspace to output down";
        "${cfg.modifier}+Control+Up" = "move workspace to output up";
        "${cfg.modifier}+Control+Right" = "move workspace to output right";

        # Splits
        "${cfg.modifier}+b" = "splith";
        "${cfg.modifier}+v" = "splitv";

        # Layouts
        "${cfg.modifier}+s" = "layout stacking";
        "${cfg.modifier}+t" = "layout tabbed";
        "${cfg.modifier}+e" = "layout toggle split";
        "${cfg.modifier}+f" = "fullscreen toggle";

        "${cfg.modifier}+a" = "focus parent";

        "${cfg.modifier}+Control+space" = "floating toggle";
        "${cfg.modifier}+space" = "focus mode_toggle";

        # Scratchpad
        "${cfg.modifier}+Shift+minus" = "move scratchpad";
        "${cfg.modifier}+minus" = "scratchpad show";

        # Resize mode
        "${cfg.modifier}+r" = "mode resize";

        # # Multimedia Keys
        # "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        # "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        # "--locked XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        # "--locked XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        # "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
        # "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";

        # "XF86AudioPrev" = "exec ${pkgs.mpc_cli}/bin/mpc -q next";
        # "XF86AudioNext" = "exec ${pkgs.mpc_cli}/bin/mpc -q prev";
        # "XF86AudioPlay" = "exec ${pkgs.mpc_cli}/bin/mpc -q toggle";
        # "XF86AudioPause" = "exec ${pkgs.mpc_cli}/bin/mpc -q toggle";

        # # Mumble PTT
        # "--no-repeat Shift_R" = "exec ${pkgs.dbus}/bin/dbus-send --session --type=method_call --dest=net.sourceforge.mumble.mumble / net.sourceforge.mumble.Mumble.startTalking";
        # "--no-repeat --release Shift_R" = "exec ${pkgs.dbus}/bin/dbus-send --session --type=method_call --dest=net.sourceforge.mumble.mumble / net.sourceforge.mumble.Mumble.stopTalking";
        # # reset
        # "Shift_R+Shift" = "exec ${pkgs.dbus}/bin/dbus-send --session --type=method_call --dest=net.sourceforge.mumble.mumble / net.sourceforge.mumble.Mumble.stopTalking";

        # Locking and DPMS
        "${cfg.modifier}+Escape" = "exec ${lock}";
        "Pause" = "exec ${lock}";
        "--no-repeat --locked ${cfg.modifier}+q" = ''exec 'test $(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq "[.[].dpms] | any") = "true" && swaymsg "output * dpms off" || swaymsg "output * dpms on"'';
      };
    };
    extraConfig = ''
    '';
  };

  home.packages = with pkgs; [
    swayidle
    wl-clipboard
    mako
    alacritty
    wdisplays
    clipman
    kanshi
    light
    i3status
    sway-contrib.grimshot # screenshots
  ];
}