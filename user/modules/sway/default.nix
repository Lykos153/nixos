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
        "type:keyboard" = {
          xkb_layout = "de";
          xkb_numlock = "enable";
          tap = "enable";
          natural_scroll = "enable";
        };
        "type:touchpad" = {
          tap = "enable";
          natural_scroll = "enable";
        };
      };

      workspaceAutoBackAndForth = true;


      fonts = {
        names = [ "monospace" ];
        style = "Regular";
        size = 10.0;
      };

      bars = [ ]; # managed as systemd user unit

    };
    extraConfig = ''
        for_window [app_id="firefox"] inhibit_idle fullscreen
        for_window [class="Firefox"] inhibit_idle fullscreen
        for_window [class="firefox"] inhibit_idle fullscreen

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
          "PATH" # or else apps won't see xdg-open. TODO: a more specific solution
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

  systemd.user.services.avizo = {
    Unit.PartOf = [ "sway-session.target" ];
    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.avizo}/bin/avizo-service
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

  xsession.preferStatusNotifierItems = true;

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
    libnotify # screenshots
    bemenu
    avizo # volumectl, lightctl
    pamixer # for avizo. TODO: wrap pamixer inside avizo?
  ];


  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
    iconTheme = {
      name = "Numix";
      package = pkgs.numix-icon-theme;
    };
  };

  #TODO: maybe make all of those a derivation some day
  home.file.".local/bin/_sway_exit_menu".source = ./exit_menu.sh;
  home.file.".local/bin/_sway_poweroff_menu".source = ./poweroff_menu.sh;
  home.file.".local/bin/screenshot".source = ./screenshot.sh;
  home.file.".local/bin/_sway_utils".source = ./lib.sh;

  programs.mako = {
    enable = true;
    anchor = "bottom-right";
    defaultTimeout = 5000;
  };
}
