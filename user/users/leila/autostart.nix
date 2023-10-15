{pkgs, ...}: {
  systemd.user.services.telegram-desktop = {
    Unit = {
      PartOf = ["sway-session.target"];
    };

    Install.WantedBy = ["sway-session.target"];

    Service = {
      ExecStart = ''
        ${pkgs.tdesktop}/bin/telegram-desktop
      '';
      Restart = "on-failure";
    };
  };
}
