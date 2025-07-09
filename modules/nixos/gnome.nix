{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.booq.gnome;
in {
  options.booq.gnome = {
    enable = lib.mkEnableOption "gnome";
  };
  config = lib.mkIf cfg.enable {
    booq.gui.enable = true;

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    environment.gnome.excludePackages = with pkgs; [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gedit # text editor
      gnome-characters
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
      totem # video player
    ];
  };
}
