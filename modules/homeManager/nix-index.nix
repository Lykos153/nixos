{
  pkgs,
  lib,
  config,
  ...
}: {
  options.booq.nix-index.enable = lib.mkEnableOption "nix-index";
  options.booq.nix-index.nixpkgs-path = lib.mkOption {
    default = null;
    type = lib.types.path;
  };
  config = lib.mkIf config.booq.nix-index.enable {
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
        ExecStart = "${pkgs.nix-index}/bin/nix-index -f ${config.booq.nix-index.nixpkgs-path}";
        Type = "simple";
      };
    };
  };
}
