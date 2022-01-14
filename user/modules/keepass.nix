{ config, lib, nixosConfig, pkgs, ... }:
{
  home.packages = with pkgs; [
    keepassxc
  ];

  systemd.user.services.keepassxc = {
    Unit.PartOf = [ "sway-session.target" ];
    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${pkgs.keepassxc}/bin/keepassxc
      '';
      Restart = "always";
    };
  };
}
