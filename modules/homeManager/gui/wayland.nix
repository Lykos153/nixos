{
  config,
  lib,
  pkgs,
  ...
}: {
  options.booq.gui.wayland.enable = lib.mkEnableOption "Wayland";
  config = lib.mkIf config.booq.gui.wayland.enable {
    services.kanshi.enable = true;
    home.packages = with pkgs; [
      wdisplays
    ];
  };
}
