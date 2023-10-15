{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.nix-index];

  systemd.user.timers."nix-index" = {
    Install.WantedBy = ["timers.target"];
    Timer = {
      OnCalendar = "weekly";
      Persistent = "true";
      Unit = "nix-index.service";
    };
  };

  systemd.user.services."nix-index" = {
    Service = {
      ExecStart = "${pkgs.nix-index}/bin/nix-index -f ${config.booq.nixpkgs-path}";
      Type = "simple";
    };
  };
}
