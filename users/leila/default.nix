# hier ist eigentlich alles drin

{pkgs, ...}: {
  booq.full.enable = true;

  booq.gui.enable = true;
  booq.gui.sway.enable = false;
  booq.gui.xmonad.enable = false;

  programs.git.userEmail = "leila@booq.org";
  programs.git.userName = "Leila Höll";

  nixpkgs.config.allowUnfree = true;

  home.keyboard.layout = "de";

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  services.gnome-keyring.enable = true;

  programs.zellij.enable = true;
  programs.bat = {
    enable = true;
    config = {
      tabs = "4";
    };
  };

# gibt eine website https://mynixos.com da gibst du ein was du installieren willst
# oder was du einstellen willst und dann kannst du das hier setzen


# diese liste hier enthält einfach pakete die erkennst du an dem package vorne darn
# und dann kommen die da unten rein
# manche haben extra settings so wie die da oben.

# das ist das paket. das kannst du einfach da unten rein schreiben
# und das ist die home-manager option dazu. die kannst du stattdessen benutzen wenn du direkt einstellungen festlegen willst

# aber es reicht auch wenn du nur das paket installierst meistens. das aktualiesrt sich bei einem betriebsystem update mit.

# das letzte konnte aber nicht bauen wegen qgis

# `mynix upgrade` machts nicht wenns dirty is

# `gg` das ist ne tui für git. 

  home.packages = with pkgs; [
    vifm
    htop
    pwgen
    jc
    jq
    jless
    yq
    mr
    ripgrep
    fd # simpler find
    ncdu
    python3Packages.ipython
    screen
    pv
    unzip
    moreutils
    tldr
    lsd # new ls
    sd # new sed
    pulsemixer

    xboxdrv

    android-file-transfer

    gedit
    gnome.file-roller
    feh # image viewer
    darktable
    solaar # TODO udev rules https://search.nixos.org/packages?channel=unstable&show=solaar&from=0&size=50&sort=relevance&type=packages&query=solaar
    clementine
    (qgis-ltr.override {
      extraPythonPackages = ps: [
        ps.pandas
      ];
    })

    tdesktop # telegram
    signal-desktop #signal
    # unfree
    zoom-us
    spotify
    gitkraken
    playonlinux
    morgen
  ];

  imports = [
    ./sway.nix
    ./waybar.nix
    ./sway.nix
    ./autostart.nix
    ./default-apps.nix
    ./state-version.nix
  ];
}
