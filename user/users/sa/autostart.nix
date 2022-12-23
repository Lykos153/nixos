{config, pkgs, ...}:
{
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

  systemd.user.services.rocketchat-desktop = {
    Unit = {
      PartOf = [ "sway-session.target" ];
    };

    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.rocketchat-desktop}/bin/rocketchat-desktop
      '';
      Restart = "on-failure";
    };
  };

  systemd.user.services.konversation = {
    Unit = {
      PartOf = [ "sway-session.target" ];
    };

    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.konversation}/bin/konversation
      '';
      Restart = "on-failure";
    };
  };
}
