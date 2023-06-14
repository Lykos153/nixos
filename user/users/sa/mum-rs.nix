{ pkgs, ... }:
let
  mum = pkgs.lykos153.mum;
in
{
  home.packages = with pkgs; [
    mum
  ];

  systemd.user.services.mumd = {
    Unit.PartOf = [ "sway-session.target" ];
    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = ''
        ${mum}/bin/mumd
      '';
      Restart = "on-failure";
    };
  };
}
