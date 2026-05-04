{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.booq.talon;
in {
  options.booq.talon.enable = lib.mkEnableOption "talon";
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
    programs.vscode.extensions = with pkgs; [
      open-vsx.pokey.cursorless
      open-vsx.pokey.parse-tree
      open-vsx.pokey.command-server
    ];
    programs.vscode.userSettings."cursorless.colors.dark" = {
      "default" = "#AAA7BB";
      "blue" = "#0870FF";
      "green" = "#36CC3F";
      "red" = "#992222";
      "pink" = "#FE7F9C";
      "yellow" = "#E5C02C";
    };
    home.file.".talon/user/cursorless-talon".source = pkgs.repos.cursorless-talon;
    # home.file.".talon/user/talon-community".source = pkgs.repos.talon-community;
    # TODO: define general method for dynamic config files. or move back to ^ once my config stabilizes
    home.file.".talon/user/talon-community".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/ghq/github.com/talonhub/community";
  };
}
