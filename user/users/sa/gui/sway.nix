{pkgs, config, ...}:
let
  cfg = config.wayland.windowManager.sway.config;
  lockcmd = "${pkgs.swaylock}/bin/swaylock -f -c000000";
  workspace_chat = "Chat";
in
{
  wayland.windowManager.sway.config = {
      keybindings = {
        # Basics
        "${cfg.modifier}+Return" = "exec ${cfg.terminal}";
        "${cfg.modifier}+d" = "exec ${cfg.menu}";
        "${cfg.modifier}+Shift+q" = "kill";
        "${cfg.modifier}+Shift+r" = "reload";
        "${cfg.modifier}+Shift+e" = "exec _sway_exit_menu";
        "${cfg.modifier}+Shift+p" = "exec _sway_poweroff_menu";

        # Focus
        "${cfg.modifier}+${cfg.left}" = "focus left";
        "${cfg.modifier}+${cfg.down}" = "focus down";
        "${cfg.modifier}+${cfg.up}" = "focus up";
        "${cfg.modifier}+${cfg.right}" = "focus right";

        "${cfg.modifier}+Left" = "focus left";
        "${cfg.modifier}+Down" = "focus down";
        "${cfg.modifier}+Up" = "focus up";
        "${cfg.modifier}+Right" = "focus right";

        # using tab
        "${cfg.modifier}+Tab"       = "focus right";
        "${cfg.modifier}+Shift+Tab" = "focus left";

        # using the scrollwheel
        "--whole-window ${cfg.modifier}+button4" = "exec _sway_utils scrollwheel_focus up";
        "--whole-window ${cfg.modifier}+button5" = "exec _sway_utils scrollwheel_focus down";

        # Moving
        "${cfg.modifier}+Shift+${cfg.left}" = "move left";
        "${cfg.modifier}+Shift+${cfg.down}" = "move down";
        "${cfg.modifier}+Shift+${cfg.up}" = "move up";
        "${cfg.modifier}+Shift+${cfg.right}" = "move right";

        "${cfg.modifier}+Shift+Left" = "move left";
        "${cfg.modifier}+Shift+Down" = "move down";
        "${cfg.modifier}+Shift+Up" = "move up";
        "${cfg.modifier}+Shift+Right" = "move right";

        "${cfg.modifier}+x" = "exec _sway_utils container-to-other-output";

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

        # using the scrollwheel
        "--whole-window ${cfg.modifier}+Alt+button4" = "exec _sway_utils previous_workspace";
        "--whole-window ${cfg.modifier}+Alt+button5" = "exec _sway_utils next_workspace";

        # Using Ctrl and Alt
        "${cfg.modifier}+Alt+Left" = "workspace prev";
        "${cfg.modifier}+Alt+Right" = "workspace next";

        # Chat workspace
        "${cfg.modifier}+Shift+less" = "move container to workspace ${workspace_chat}";
        "${cfg.modifier}+Shift+minus" = "move container to workspace ${workspace_chat}";
        "${cfg.modifier}+less" = "workspace ${workspace_chat}";
        "${cfg.modifier}+minus" = "workspace ${workspace_chat}";

        # Moving workspaces between outputs
        "${cfg.modifier}+Control+${cfg.left}" = "move workspace to output left";
        "${cfg.modifier}+Control+${cfg.down}" = "move workspace to output down";
        "${cfg.modifier}+Control+${cfg.up}" = "move workspace to output up";
        "${cfg.modifier}+Control+${cfg.right}" = "move workspace to output right";

        "${cfg.modifier}+Control+Left" = "move workspace to output left";
        "${cfg.modifier}+Control+Down" = "move workspace to output down";
        "${cfg.modifier}+Control+Up" = "move workspace to output up";
        "${cfg.modifier}+Control+Right" = "move workspace to output right";

        "${cfg.modifier}+Shift+x" = "exec _sway_utils workspace-to-other-output";
        "${cfg.modifier}+Shift+y" = "exec _sway_utils switch-outputs";

        # Splits
        "${cfg.modifier}+b" = "splith";
        "${cfg.modifier}+v" = "splitv";

        # Layouts
        "${cfg.modifier}+s" = "layout stacking";
        "${cfg.modifier}+w" = "layout tabbed";
        "${cfg.modifier}+e" = "layout toggle split";
        "${cfg.modifier}+f" = "fullscreen toggle";

        "${cfg.modifier}+a" = "focus parent";
        "${cfg.modifier}+Shift+a" = "focus child";

        "${cfg.modifier}+Shift+space" = "floating toggle";
        "${cfg.modifier}+space" = "focus mode_toggle";


        # Resize mode
        "${cfg.modifier}+r" = "mode resize";

        # # Multimedia Keys
        "XF86AudioMute" = "exec ${pkgs.avizo}/bin/volumectl toggle-mute";
        "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "--locked XF86MonBrightnessDown" = "exec ${pkgs.avizo}/bin/lightctl down";
        "--locked XF86MonBrightnessUp" = "exec ${pkgs.avizo}/bin/lightctl up";
        "XF86AudioRaiseVolume" = "exec ${pkgs.avizo}/bin/volumectl -u up";
        "XF86AudioLowerVolume" = "exec ${pkgs.avizo}/bin/volumectl -u down";

        # "XF86AudioPrev" = "exec ${pkgs.mpc_cli}/bin/mpc -q next";
        # "XF86AudioNext" = "exec ${pkgs.mpc_cli}/bin/mpc -q prev";
        # "XF86AudioPlay" = "exec ${pkgs.mpc_cli}/bin/mpc -q toggle";
        # "XF86AudioPause" = "exec ${pkgs.mpc_cli}/bin/mpc -q toggle";

        # # Mumble PTT
        # "--no-repeat Shift_R" = "exec ${pkgs.dbus}/bin/dbus-send --session --type=method_call --dest=net.sourceforge.mumble.mumble / net.sourceforge.mumble.Mumble.startTalking";
        # "--no-repeat --release Shift_R" = "exec ${pkgs.dbus}/bin/dbus-send --session --type=method_call --dest=net.sourceforge.mumble.mumble / net.sourceforge.mumble.Mumble.stopTalking";
        # # reset
        # "Shift_R+Shift" = "exec ${pkgs.dbus}/bin/dbus-send --session --type=method_call --dest=net.sourceforge.mumble.mumble / net.sourceforge.mumble.Mumble.stopTalking";

        # Screenshots
        "Print" = "exec screenshot screen";
        "Ctrl+Print" = "exec screenshot area";

        # Clipboard
          "${cfg.modifier}+c" = "exec clipman pick --tool dmenu";

        # Locking and DPMS
        "${cfg.modifier}+Escape" = "exec ${lockcmd}";
        "Pause" = "exec ${lockcmd}";
        "--no-repeat --locked ${cfg.modifier}+Pause" = ''exec 'test $(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq "[.[].dpms] | any") = "true" && swaymsg "output * dpms off" || swaymsg "output * dpms on"'';
      };

      assigns = {
        "2" = [
          { app_id="firefox"; }
          { class="Firefox"; }
          { class="firefox"; }
        ];
        "3" = [
          { app_id="thunderbird"; }
          { class="Thunderbird"; }
          { class="thunderbird"; }
        ];
        ${workspace_chat} = [
          { class="Element"; }
          { class="SchildiChat"; }
          { app_id="org.gajim.Gajim"; title="Gajim"; }
          { app_id="telegramdesktop"; }
        ];
      };
  };
}
