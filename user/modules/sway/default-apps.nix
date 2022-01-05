{ config, lib, nixosConfig, pkgs, ... }:
{
    config.home.packages = with pkgs; [
        xdg-utils
    ];

    options.xdg-mime-apps = {
        enable = true;
        defaultApplications = {
            "text/html" = "firefox.desktop";
        };
    };
}