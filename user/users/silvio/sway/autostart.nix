{ config, lib, pkgs, ... }:
lib.mkIf (config.booq.gui.enable && config.booq.gui.sway.enable) {
  systemd.user.services.nextcloud-client = {
    Unit = {
      Description = "Nextcloud Client";
      PartOf = [ "sway-session.target" ];
      Wants = [ "keepassxc.service" ];
      After = [ "keepassxc.service" ];
    };
    Install.WantedBy = [ "sway-session.target" ];
    Service = {
      Environment = "PATH=${config.home.profileDirectory}/bin";
      ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
    };
  };

  systemd.user.services.gajim = {
    Unit = {
      PartOf = [ "sway-session.target" ];
    };

    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.gajim}/bin/gajim
      '';
      Restart = "on-failure";
    };
  };
}
