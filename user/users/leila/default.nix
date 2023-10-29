{pkgs, ...}: {
  booq.gui.enable = true;
  booq.gui.sway.enable = false;
  booq.gui.xmonad.enable = false;

  programs.git.userEmail = "leila@booq.org";
  programs.git.userName = "Leila Höll";

  home.packages = with pkgs; [
    xboxdrv

    android-file-transfer

    gnome.gedit
    gnome.file-roller
    feh # image viewer
    darktable
    solaar # TODO udev rules https://search.nixos.org/packages?channel=unstable&show=solaar&from=0&size=50&sort=relevance&type=packages&query=solaar
    clementine

    tdesktop # telegram

    # unfree
    zoom-us
    spotify
    steam
    gitkraken
    playonlinux
  ];

  imports = [
    ./sway.nix
    ./waybar.nix
    ./sway.nix
    ./autostart.nix
    ./default-apps.nix
  ];
}
