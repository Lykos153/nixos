{pkgs, ...}: {
  systemd.user.services.telegram-desktop = {
    Unit = {
      PartOf = ["sway-session.target"];
    };

    Install.WantedBy = ["sway-session.target"];

    Service = {
      ExecStart = ''
        ${pkgs.telegram-desktop}/bin/telegram-desktop
      '';
      Restart = "on-failure";
    };
  };
}
