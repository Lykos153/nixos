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

    android-file-transfer

    gedit
    file-roller
    feh # image viewer
    darktable
    solaar # TODO udev rules https://search.nixos.org/packages?channel=unstable&show=solaar&from=0&size=50&sort=relevance&type=packages&query=solaar
    clementine
    (qgis-ltr.override {
      extraPythonPackages = ps: [
        ps.pandas
      ];
    })

    librecad
    freecad

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
