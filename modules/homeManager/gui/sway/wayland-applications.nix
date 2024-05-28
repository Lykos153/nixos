# Originally from https://git.sbruder.de/simon/nixos-config/raw/commit/540f89bff111c2ff10f6d809f61806082616f981/users/simon/modules/sway/waybar.nix
{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.booq.gui.sway.enable {
  programs.firefox.package = pkgs.firefox-wayland;
}
