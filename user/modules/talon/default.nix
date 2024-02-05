{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.booq.talon;
in {
  options.booq.talon.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };
  config = lib.mkIf cfg.enable {
    booq.lib.allowUnfreePackages = [
      "talon"
    ];

    home.packages = [
      pkgs.talon
    ];

    systemd.user.services.talon = {
      Unit = {
        PartOf = ["graphical-session.target"];
      };

      Install.WantedBy = ["graphical-session.target"];

      Service = {
        ExecStart = ''
          ${pkgs.talon}/bin/talon
        '';
        Restart = "on-failure";
      };
    };

    home.file.".talon/user/cursorless-talon".source = pkgs.repos.cursorless-talon;
    home.file.".talon/user/rango".source = pkgs.repos.rango;
    home.file.".talon/user/talon-community".source = pkgs.repos.talon-community;
  };
}
