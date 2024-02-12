{
  config,
  lib,
  pkgs,
  ...
}: let
  okular-x11 = pkgs.symlinkJoin {
    name = "okular";
    paths = [pkgs.okular];
    buildInputs = [pkgs.makeWrapper];
    # force okular to use xwayland, because of https://github.com/swaywm/sway/issues/4973
    postBuild = ''
      wrapProgram $out/bin/okular \
        --set QT_QPA_PLATFORM xcb
    '';
  };
in {
  options.booq.gui.enable = lib.mkEnableOption "gui";
  config = lib.mkIf config.booq.gui.enable {
    programs = {
      firefox = {
        enable = true;
        profiles = {
          default = {
            settings = {
              "browser.translations.neverTranslateLanguages" = "de";
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
      chromium.enable = true;
    };

    home.packages = with pkgs; [
      termite
      gajim
      thunderbird
      element-desktop
      fractal
      pavucontrol
      libreoffice
      nomacs
      okular-x11
      xfce.thunar
      vlc
      system-config-printer
    ];

    gtk = {
      enable = true;
      theme = lib.mkDefault {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
      iconTheme = {
        name = "Numix";
        package = pkgs.numix-icon-theme;
      };
    };

    services = {
      udiskie.enable = true;
      blueman-applet.enable = true;
      pasystray.enable = true;
    };

    home.sessionVariables = lib.mkIf config.booq.gui.sway.enable {
      # MOZ_ENABLE_WAYLAND = "1"; not yet, because of https://github.com/swaywm/wlroots/issues/3189
    };
  };
}
