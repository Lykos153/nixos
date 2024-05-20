{
  lib,
  config,
  ...
}: {
  imports = [
    ./config.nix
    ./kanshi.nix
    ./waybar.nix
    ./autostart.nix
    ./xdg-desktop-portal.nix
    ./wayland-applications.nix
  ];
  options.booq.gui.sway.enable = lib.mkEnableOption "sway";
  config = lib.mkIf config.booq.gui.sway.enable {
    booq.gui.enable = true;
  };
}
