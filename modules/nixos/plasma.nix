{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.booq.plasma;
in {
  options.booq.plasma = {
    enable = lib.mkEnableOption "plasma";
  };
  config = lib.mkIf cfg.enable {
    booq.gui.enable = true;

    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      oxygen
    ];

    environment.systemPackages = with pkgs; [
      xsettingsd
      xorg.xrdb
    ];
  };
}
