{ config, lib, nixosConfig, pkgs, ... }:
let
    defaultBrowser = "firefox.desktop";
in
{
    config.home.packages = with pkgs; [
        xdg-utils
    ];

    config.xdg.mimeApps = {
        enable = true;
        associations.added = {
            "text/x-tex" = "codium.desktop";
            "x-scheme-handler/tg" = "userapp-Telegram Desktop-0IRXQ1.desktop";
        };
        defaultApplications = {
            "text/html" = defaultBrowser;
            "x-scheme-handler/http" = defaultBrowser;
            "x-scheme-handler/https" = defaultBrowser;
            "x-scheme-handler/about" = defaultBrowser;
            "x-scheme-handler/unknown" = defaultBrowser;
            "application/pdf" = "okularApplication_pdf.desktop";
            "x-scheme-handler/tg" = "userapp-Telegram Desktop-0IRXQ1.desktop";
        };
    };
}
