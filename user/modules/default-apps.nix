{ config, lib, nixosConfig, pkgs, ... }:
let
    defaultBrowser = "firefox.desktop";
in
{
    config = lib.mkIf config.booq.gui.enable {
        home.packages = with pkgs; [
            xdg-utils
        ];

        xdg.mimeApps = {
            enable = true;
            associations.added = {
                "text/x-tex" = "codium.desktop";
            };
            defaultApplications = {
                "text/html" = defaultBrowser;
                "x-scheme-handler/http" = defaultBrowser;
                "x-scheme-handler/https" = defaultBrowser;
                "x-scheme-handler/about" = defaultBrowser;
                "x-scheme-handler/unknown" = defaultBrowser;
                "application/pdf" = "okularApplication_pdf.desktop";
                "inode/directory" = "thunar.desktop";
            };
        };
    };
}
