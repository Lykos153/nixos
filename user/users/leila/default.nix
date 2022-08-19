{pkgs, ...}:
{
  programs.git.userEmail = "leila@booq.org";
  programs.git.userName = "Leila Höll";

  home.packages = with pkgs; [
    xboxdrv

    android-file-transfer

    gnome.gedit
    feh # image viewer
    darktable
    solaar # TODO udev rules https://search.nixos.org/packages?channel=unstable&show=solaar&from=0&size=50&sort=relevance&type=packages&query=solaar

    tdesktop # telegram

    # unfree
    zoom-us
    spotify
    steam
    geogebra
    gitkraken
    playonlinux
  ];

  imports = [
    ./sway.nix
    ./waybar.nix
    ./sway.nix
    ./autostart.nix
    ./zsh.nix
    ./default-apps.nix
  ];
}
