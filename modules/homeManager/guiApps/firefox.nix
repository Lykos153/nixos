{
  config,
  lib,
  ...
}: let
  cfg = config.booq.firefox;
in {
  options.booq.firefox = {
    enable = lib.mkEnableOption "firefox";
  };
  config = lib.mkIf cfg.enable {
    booq.gui.defaultApps.browser = "firefox.desktop";
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          settings = {
            "browser.translations.neverTranslateLanguages" = "de";
            "browser.tabs.unloadOnLowMemory" = true;
          };
          search = {
            force = true;
            default = "DuckDuckGo";
            privateDefault = "DuckDuckGo";
            order = ["Nix Packages" "NixOS Wiki"];
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

                definedAliases = ["@np"];
              };

              "NixOS Wiki" = {
                urls = [
                  {
                    template = "https://nixos.wiki/index.php?search={searchTerms}";
                  }
                ];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@nw"];
              };

              "Google".metaData.alias = "@g";
            };
          };
        };
      };
    };
  };
}
