{ pkgs, ... }:
let
  mum = pkgs.lykos153.mum;
in
{
  home.packages = with pkgs; [
    mum
  ];

  systemd.user.services.mumd = {
    Unit.PartOf = [ "default.target" ];
    Unit.After = [ "pipewire.service" ];
    Install.WantedBy = [ "default.target" ];

    Service = {
      ExecStart = ''
        ${mum}/bin/mumd
      '';
      Restart = "always";
    };
  };
}
