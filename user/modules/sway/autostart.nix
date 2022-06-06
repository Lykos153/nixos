{ config, lib, nixosConfig, pkgs, ... }:
{
  systemd.user.services.firefox = {
    Unit.PartOf = [ "sway-session.target" ];
    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.firefox}/bin/firefox
      '';
      Restart = "on-failure";
    };
  };

  systemd.user.services.thunderbird = {
    Unit.PartOf = [ "sway-session.target" ];
    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.thunderbird}/bin/thunderbird
      '';
      Restart = "on-failure";
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

  systemd.user.services.element-desktop = {
    Unit = {
      PartOf = [ "sway-session.target" ];
    };

    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.element-desktop}/bin/element-desktop
      '';
      Restart = "on-failure";
    };
  };

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

  systemd.user.services.autotiling = {
    Unit.PartOf = [ "sway-session.target" ];
    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.autotiling}/bin/autotiling
      '';
      Restart = "on-failure";
    };
  };
}
