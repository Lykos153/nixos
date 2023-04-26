{ config, lib, ... }:
lib.mkIf config.booq.gui.enable {
  services.gammastep = {
    enable = true;
#    inherit (nixosConfig.location) latitude longitude;
#     ^why doesn't this work?
#    provider = "geoclue2";

    tray = true;

    latitude = 51.05;
    longitude = 13.73;
    temperature = {
      day = 6500;
      night = 2500;
    };
    settings = {
      general = {
        brightness-day = "1.0";
        brightness-night = "1.0";
      };
    };
  };
}
