{ config, lib, pkgs, ... }:
lib.mkIf (config.booq.gui.enable && config.booq.gui.sway.enable) {
  systemd.user.services.schildichat-desktop = {
    Unit = {
      PartOf = [ "sway-session.target" ];
    };

    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.schildichat-desktop}/bin/schildichat-desktop
      '';
      Restart = "on-failure";
    };
  };
}
