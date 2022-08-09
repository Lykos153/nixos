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
    layer = "top";
    position = "bottom";
    height = 24;

    modules-center = [
      "sway/mode"
    ];
    modules-left = [
      "sway/workspaces"
    ];
    modules-right = [
      "custom/redshift"
      "idle_inhibitor"
      "backlight"
      "pulseaudio"
      "network"
      "memory"
      "cpu"
      "battery"
      "tray"
      "clock"
    ];

    "sway/workspaces" = {
      disable-scroll = false;
      disable-scroll-wraparound = true;
      enable-bar-scroll = true;
    };
    "sway/mode" = {
      format = "{}";
    };

    tray = {
      spacing = 5;
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
      format-icons = {
        activated = " ";
        deactivated = " ";
      };
    };
    backlight = {
      format = "{percent}% {icon}";
      format-icons = [ " " " " " " " " " " " " " " ];
      on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl -q set +5%";
      on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl -n5 -q set 5%-";
    };
    pulseaudio = {
      format = "{volume}% {icon} {format_source}";
      format-bluetooth = "{volume}% {icon} {format_source}";
      format-bluetooth-muted = "${lrm}ﱝ${lrm}  {icon} {format_source}";
      format-muted = "${lrm}ﱝ${lrm}  {format_source}";
      format-source = "{volume}% ${thinsp}";
      format-source-muted = "${thinsp}";
      format-icons = {
        car = " ";
        default = [ "奄" "奔" "墳" ];
        hands-free = " ";
        headphone = " ";
        headset = " ";
        phone = " ";
        portable = " ";
      };
      on-click = "${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle";
      on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
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
    clock = {
      interval = 1;
      format = "{:%a %Y-%m-%d (%V) %H:%M:%S %Z}";
      on-click = "";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
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
