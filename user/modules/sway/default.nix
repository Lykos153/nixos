{lib, ...}: {
  imports = [
    ./config.nix
    ./kanshi.nix
    ./waybar.nix
    ./autostart.nix
    ./xdg-desktop-portal.nix
  ];
  options.booq.gui.sway.enable = lib.mkEnableOption "sway";
}
