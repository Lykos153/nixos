# More inspiration: https://git.sbruder.de/simon/nixos-config/src/branch/master/users/simon/modules/sway/default.nix
{ config, lib, nixosConfig, pkgs, ... }:
let
  cfg = config.wayland.windowManager.sway.config;
  lockcmd = "${pkgs.swaylock}/bin/swaylock -f -c000000";
  workspace_chat = "Chat";
in
{
  imports = [
    ./kanshi.nix
    ./gammastep.nix
    ./waybar.nix
    ./default-apps.nix
    ./autostart.nix
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
          xkb_numlock = "enable";
        };
      };

      workspaceAutoBackAndForth = true;

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

        # Screenshots
        "Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save screen Bilder/Screenshots/$(date +'%Y-%m-%d-%H%M%S.png')";
        "Ctrl+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save area Bilder/Screenshots/$(date +'%Y-%m-%d-%H%M%S.png')";

        # Clipboard
          "${cfg.modifier}+c" = "exec clipman pick --tool dmenu";

        # Locking and DPMS
        "${cfg.modifier}+Escape" = "exec ${lockcmd}";
        "Pause" = "exec ${lockcmd}";
        "--no-repeat --locked ${cfg.modifier}+Pause" = ''exec 'test $(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq "[.[].dpms] | any") = "true" && swaymsg "output * dpms off" || swaymsg "output * dpms on"'';
      };

      fonts = {
        names = [ "monospace" ];
        style = "Regular";
        size = 10.0;
      };

      bars = [ ]; # managed as systemd user unit

      assigns = {
        "2" = [
          { app_id="firefox"; }
          { class="Firefox"; }
        ];
        "3" = [
          { app_id="thunderbird"; }
          { class="Thunderbird"; }
        ];
        ${workspace_chat} = [
          { class="Element"; }
          { app_id="org.gajim.Gajim"; title="Gajim"; }
        ];
      };
    };
    extraConfig = ''
        for_window [app_id="firefox"] inhibit_idle fullscreen
        for_window [class="Firefox"] inhibit_idle fullscreen

        for_window [shell="xwayland"] title_format "%title (XWayland)"

        # Workaround for https://todo.sr.ht/~emersion/kanshi/35
        exec_always "systemctl --user restart kanshi.service"
    '' + (
      let
        environmentVariables = lib.concatStringsSep " " [
          "DBUS_SESSION_BUS_ADDRESS"
          "DISPLAY"
          "SWAYSOCK"
          "WAYLAND_DISPLAY"
        ];
      in
      ''
        # From https://github.com/swaywm/sway/wiki#gtk-applications-take-20-seconds-to-start
        exec systemctl --user import-environment ${environmentVariables} && \
          hash dbus-update-activation-environment 2>/dev/null && \
          dbus-update-activation-environment --systemd ${environmentVariables} && \
          systemctl --user start sway-session.target
      ''
    );
  };

  systemd.user.targets.sway-session = {
    Unit = {
      Description = "sway compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  systemd.user.services.swayidle = {
    Unit.PartOf = [ "sway-session.target" ];
    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      # swayidle requires sh and swaymsg to be in path
      Environment = "PATH=${pkgs.bash}/bin:${config.wayland.windowManager.sway.package}/bin";
      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle -w \
            timeout 300 "${lockcmd}" \
            timeout 300 'swaymsg "output * dpms off"' \
                resume 'swaymsg "output * dpms on"' \
            before-sleep "${lockcmd}"
      '';
      Restart = "on-failure";
    };
  };

  systemd.user.services.clipman = {
    Unit.PartOf = [ "sway-session.target" ];
    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.wl-clipboard}/bin/wl-paste -p -t text --watch ${pkgs.clipman}/bin/clipman store -P
      '';
      Restart = "on-failure";
    };
  };

  # Start on tty1
  programs.zsh.initExtra = /* sh */ ''
    if [[ -z $WAYLAND_DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        export XDG_SESSION_TYPE="wayland" # otherwise set to tty
        unset __HM_SESS_VARS_SOURCED __NIXOS_SET_ENVIRONMENT_DONE # otherwise sessionVariables are not updated
        exec systemd-cat -t sway sway
    fi
  '';

  home.sessionVariables = {
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    GDK_DPI_SCALE = 1;
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland-egl";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    SDL_VIDEODRIVER = "wayland";
    WLR_NO_HARDWARE_CURSORS = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on";
  };

  home.packages = with pkgs; [
    swayidle
    wl-clipboard
    alacritty
    wdisplays
    clipman
    light
    brightnessctl
    i3status
    sway-contrib.grimshot # screenshots
    bemenu
    gnome3.adwaita-icon-theme
  ];

  #TODO: maybe make all of those a derivation some day
  home.file.".local/bin/_sway_exit_menu".source = ./exit_menu.sh;
  home.file.".local/bin/_sway_poweroff_menu".source = ./poweroff_menu.sh;
  home.file.".local/bin/_sway_utils".source = ./lib.sh;

  programs.mako = {
    enable = true;
    anchor = "bottom-right";
    defaultTimeout = 5000;
  };
}
