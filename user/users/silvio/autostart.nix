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
}
