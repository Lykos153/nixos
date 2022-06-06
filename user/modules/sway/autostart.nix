{ config, lib, nixosConfig, pkgs, ... }:
let
  element-desktop = pkgs.writeShellScriptBin "element-desktop" ''
    echo | ${pkgs.libsecret}/bin/secret-tool store --label=dummy dummy dummy &&
    exec ${pkgs.element-desktop}/bin/element-desktop
  '';
in
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
      Wants = [ "keepassxc.service" ];
      After = [ "keepassxc.service" ];
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
      Wants = [ "keepassxc.service" ];
      After = [ "keepassxc.service" ];
    };

    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${element-desktop}/bin/element-desktop
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
