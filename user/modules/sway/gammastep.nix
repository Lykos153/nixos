{ nixosConfig, ... }:

{
  services.gammastep = {
    enable = true;
#    inherit (nixosConfig.location) latitude longitude;
#     ^why doesn't this work?
#    provider = "geoclue2";

    latitude = 51.05;
    longitude = 13.73;
    temperature = {
      day = 6500;
      night = 2500;
    };
    settings = {
      general = {
        brightness-day = "1.0";
        brightness-night = "0.7";
      };
    };
  };
}
