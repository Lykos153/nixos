{ config, lib, nixosConfig, pkgs, ... }:
{
    config.xdg.mimeApps = {
        associations.added = {
            "x-scheme-handler/tg" = "userapp-Telegram Desktop-0IRXQ1.desktop";
        };
        defaultApplications = {
            "x-scheme-handler/tg" = "userapp-Telegram Desktop-0IRXQ1.desktop";
        };
    };
}
