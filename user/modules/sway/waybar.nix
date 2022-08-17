# Originally from https://git.sbruder.de/simon/nixos-config/raw/commit/540f89bff111c2ff10f6d809f61806082616f981/users/simon/modules/sway/waybar.nix

{ config, lib, nixosConfig, pkgs, ... }:
let
  watchUserUnitState = unit: started: stopped: pkgs.writeShellScript "watch-user-unit-${unit}-state" ''
    ${pkgs.systemd}/bin/journalctl --user -u ${unit} -t systemd -o cat -f \
        | ${pkgs.gnugrep}/bin/grep --line-buffered -Eo '^(Started|Stopped)' \
        | ${pkgs.jq}/bin/jq --unbuffered -Rc 'if . == "Started" then ${builtins.toJSON started} else ${builtins.toJSON stopped} end'
  '';

  toggleUserUnitState = unit: pkgs.writeShellScript "toggle-user-unit-${unit}-state" ''
    if ${pkgs.systemd}/bin/systemctl --user show ${unit} | ${pkgs.gnugrep}/bin/grep -q ActiveState=active; then
        ${pkgs.systemd}/bin/systemctl --user stop ${unit}
    else
        ${pkgs.systemd}/bin/systemctl --user start ${unit}
    fi
  '';

  # nerd fonts are abusing arabic which breaks latin text
  # context: https://github.com/Alexays/Waybar/issues/628
  lrm = "&#8206;";

  # for fine-grained control over spacing
  thinsp = "&#8201;";
in
{
  home.packages = [ (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; }) ];
  # home-manager’s waybar module performs additional checks that are overly strict
  xdg.configFile."waybar/config".onChange = ''
          ${pkgs.systemd}/bin/systemctl --user reload waybar
        '';
  xdg.configFile."waybar/config".text = lib.generators.toJSON { } {
    layer = "bottom";
    position = "top";
    height = 10;

    modules-left = [
      "sway/workspaces"
      "sway/mode"
    ];
    modules-center = [
      "sway/window"
    ];
    modules-right = [
      # "custom/redshift"
      "idle_inhibitor"
      "pulseaudio"
      "tray"
      "clock#date"
      "clock#time"
    ];

    "sway/workspaces" = {
      disable-scroll = false;
      disable-scroll-wraparound = true;
      enable-bar-scroll = true;
      format = "{icon} {name}";
      format-icons = {
          "1:WWW" = ""; # Icon: firefox-browser
          "2:Editor" = ""; # Icon: code
          "3:Terminals" = ""; # Icon: terminal
          "4:Mail" = ""; # Icon: mail
          "8:Documents" = ""; # Icon: book
          "9:Multimedia" = ""; # Icon: music
          "10:Torrent" = ""; # Icon: cloud-download-alt
          urgent = "";
          focused = "";
          default = "";
      };
    };
    "sway/mode" = {
      format = "<span style=\"italic\"> {}</span>"; # Icon: expand-arrows-alt
      tooltip = false;
    };

    "sway/window" = {
      format = "{}";
      max-length = 120;
    };

    tray = {
      icon-size = 21;
      spacing = 10;
    };
    "custom/redshift" = {
      exec = watchUserUnitState
        "gammastep"
        { class = "active"; }
        { class = "inactive"; };
      on-click = toggleUserUnitState "gammastep";
      return-type = "json";
      format = "";
      tooltip = false;
    };
    idle_inhibitor = {
        format = "{icon}";
        "format-icons" = {
            activated = "";
            deactivated = "";
        };
    };
    backlight = {
      format = "{percent}% {icon}";
      format-icons = [ " " " " " " " " " " " " " " ];
      on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl -q set +5%";
      on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl -n5 -q set 5%-";
    };
    pulseaudio = {
        scroll-step = 2;
        format = "{icon} {volume}%";
        format-muted = " Muted"; # Icon: volume-mute
        format-icons = {
            headphones = ""; # Icon: headphones
            handsfree = ""; # Icon: headset
            headset = ""; # Icon: headset
            phone = ""; # Icon: phone
            portable = ""; # Icon: phone
            car = ""; # Icon: car
            default = ["" ""]; # Icons: volume-down, volume-up
        };
        on-click = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
        tooltip = true;
    };
    network = {
      format-wifi = "{essid} ({signalStrength}%) 直 ";
      format-ethernet = "{ipaddr}/{cidr}  ";
      format-linked = "{ifname} (No IP)  ";
      format-disconnected = "Disconnected ⚠ ";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
      tooltip = false;
      on-click-right = "${config.programs.alacritty.package}/bin/alacritty -e ${pkgs.networkmanager}/bin/nmtui";
    };
    memory = {
      interval = 2;
      format = "{:2}%  ";
    };
    cpu = {
      interval = 2;
      format = "{usage:2}% ﬙ ";
      tooltip = false;
    };
    battery = {
      interval = 5;
      format = "{capacity}% {icon}";
      format-charging = "{capacity}% ";
      format-plugged = "{capacity}% ${lrm}ﮣ";
      format-alt = "{time} {icon}";
      format-icons = [ "" "" "" "" "" "" "" "" "" "" "" ];
      states = {
        critical = 15;
        good = 95;
        warning = 30;
      };
    };

    "clock#time" = {
        interval = 1;
        format = "{:%H:%M:%S}";
        tooltip = false;
    };

    "clock#date" = {
      interval = 10;
      format = " {:%e %b %Y}"; # # Icon: calendar-alt
      tooltip-format = "{:%e %B %Y}";
      locale = "de_DE.UTF-8";
      timezone = "Europe/Berlin";
    };

  };
  xdg.configFile."waybar/style.css".onChange = ''
          ${pkgs.systemd}/bin/systemctl --user restart waybar
        '';
  xdg.configFile."waybar/style.css".source = ./waybar.css;

  systemd.user.services.waybar = {
    Unit = {
      Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
      Documentation = "https://github.com/Alexays/Waybar/wiki/";
      PartOf = [ "sway-session.target" ];
    };

    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      # ensure sway is already started, otherwise workspaces will not work
      ExecStartPre = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
      ExecStart = "${pkgs.waybar}/bin/waybar";
      ExecReload = "${pkgs.utillinux}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      RestartSec = "1s";
    };
  };

  # TODO: remove when https://github.com/nix-community/home-manager/issues/2064
  # is resolved
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  #services.blueman-applet.enable = lib.mkIf nixosConfig.sbruder.full true;
}
