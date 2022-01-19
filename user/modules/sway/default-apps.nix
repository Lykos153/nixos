{ config, lib, nixosConfig, pkgs, ... }:
{
    config.home.packages = with pkgs; [
        xdg-utils
    ];

    config.xdg.mimeApps = {
        enable = true;
        defaultApplications = {
            "text/html" = "firefox.desktop";
            "application/pdf" = "okularApplication_pdf.desktop";
        };
    };
}