# Originally from https://git.sbruder.de/simon/nixos-config/raw/commit/540f89bff111c2ff10f6d809f61806082616f981/users/simon/modules/sway/waybar.nix
{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}:
lib.mkIf config.booq.gui.sway.enable {
  home.packages = [pkgs.nerd-fonts.iosevka];
  # home-manager’s waybar module performs additional checks that are overly strict
  xdg.configFile."waybar/config".onChange = ''
    ${pkgs.systemd}/bin/systemctl --user reload waybar
  '';
  xdg.configFile."waybar/style.css".onChange = ''
    ${pkgs.systemd}/bin/systemctl --user restart waybar
  '';

  systemd.user.services.waybar = {
    Unit = {
      Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
      Documentation = "https://github.com/Alexays/Waybar/wiki/";
      PartOf = ["sway-session.target"];
    };

    Install.WantedBy = ["sway-session.target"];

    Service = {
      # ensure sway is already started, otherwise workspaces will not work
      ExecStartPre = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
      ExecStart = "${pkgs.waybar}/bin/waybar";
      ExecReload = "${pkgs.util-linux}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      RestartSec = "1s";
    };
  };

  # TODO: remove when https://github.com/nix-community/home-manager/issues/2064
  # is resolved
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  #services.blueman-applet.enable = lib.mkIf nixosConfig.sbruder.full true;
}
