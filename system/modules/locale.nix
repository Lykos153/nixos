{pkgs, ...}: {
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  services.xserver.layout = "de";

  services.xserver.extraLayouts.mine = {
    description = "The latest neo variant";
    languages = ["mine"];
    symbolsFile = pkgs.fetchurl {
      url = "https://dl.neo-layout.org/mine";
      sha256 = "sha256-9zx3Iei4uSUZahlBhtgsuWI0BKMbr8ukVC4PQBlqoyw=";
    };
  };
}
