{config, pkgs, ...}:
{
  systemd.user.services.safeeyes = {
    Unit = {
      PartOf = [ "sway-session.target" ];
    };

    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.safeeyes}/bin/safeeyes
      '';
      Restart = "on-failure";
    };
  };
}
