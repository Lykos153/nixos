{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: let
  cfg = config.booq.gui;
in {
  options.booq.gui.defaultApps.browser = lib.mkOption {
    type = lib.types.str;
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      xdg-utils
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = cfg.defaultApps.browser;
        "x-scheme-handler/http" = cfg.defaultApps.browser;
        "x-scheme-handler/https" = cfg.defaultApps.browser;
        "x-scheme-handler/about" = cfg.defaultApps.browser;
        "x-scheme-handler/unknown" = cfg.defaultApps.browser;
        "application/pdf" = "okularApplication_pdf.desktop";
        "inode/directory" = "thunar.desktop";
      };
    };
  };
}
