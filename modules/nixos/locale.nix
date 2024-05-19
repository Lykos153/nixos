{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.booq.locale;
in {
  options.booq.locale = {
    enable = lib.mkEnableOption "locale";
  };
  config = lib.mkIf cfg.enable {
    time.timeZone = "Europe/Berlin";

    i18n.defaultLocale = "de_DE.UTF-8";
    console = {
      earlySetup = true; # workaround for https://github.com/NixOS/nixpkgs/issues/257904
      font = "Lat2-Terminus16";
      keyMap = "de";
    };

    services.xserver.xkb = {
      layout = "de";

      extraLayouts.mine = {
        description = "The latest neo variant";
        languages = ["mine"];
        symbolsFile = pkgs.fetchurl {
          url = "https://dl.neo-layout.org/mine";
          sha256 = "sha256-9zx3Iei4uSUZahlBhtgsuWI0BKMbr8ukVC4PQBlqoyw=";
        };
      };
    };
  };
}
