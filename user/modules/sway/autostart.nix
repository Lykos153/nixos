{ config, lib, nixosConfig, pkgs, ... }:
{
  # TODO: a more specific solution to the problem that apps from services
  #       won't see eg. xdg-open. Idea: function that creates systemd user
  #       unit and includes necessary PATHs
  systemd.user.services.firefox = {
    Unit.PartOf = [ "sway-session.target" ];
    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      Environment = [
        "MOZ_ENABLE_WAYLAND=1" #TODO: Somehow deduplicate this with thunderbird and the setting in ./default.nix
      ];
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
      Environment = [
        "MOZ_ENABLE_WAYLAND=1"
      ];
      ExecStart = ''
        ${pkgs.thunderbird}/bin/thunderbird
      '';
      Restart = "on-failure";
    };
  };

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
