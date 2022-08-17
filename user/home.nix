{ config, lib, nixosConfig, pkgs, ... }:
let
  okular-x11 = pkgs.symlinkJoin {
    name = "okular";
    paths = [ pkgs.okular ];
    buildInputs = [ pkgs.makeWrapper ];
    # force okular to use xwayland, because of https://github.com/swaywm/sway/issues/4973
    postBuild = ''
      wrapProgram $out/bin/okular \
        --set QT_QPA_PLATFORM xcb
    '';
  };
in
{
  imports = map (n: "${./modules}/${n}") (builtins.attrNames (builtins.readDir ./modules));

  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.direnv.enable = true;
  programs.password-store.enable = true;

  programs.bat = {
    enable = true;
    config = {
      tabs = "4";
    };
  };

  home.packages = with pkgs; [
    xboxdrv

    #cli applications
    vimPlugins.vim-plug
    vifm
    htop
    pwgen
    git
    git-remote-gcrypt
    git-annex
    git-annex-remote-googledrive
    tig
    jq
    yq
    mr
    ripgrep
    ncdu
    python3Packages.ipython
    screen
    pv
    unzip
    moreutils
    android-file-transfer

    # gui applications
    termite
    gajim
    thunderbird
    schildichat-desktop
    pavucontrol
    libreoffice
    nomacs
    okular-x11
    mate.caja
    vlc
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

  services.udiskie.enable = true;
  services.gnome-keyring.enable = true;
  services.blueman-applet.enable = true;

  home.sessionVariables = {
    # MOZ_ENABLE_WAYLAND = "1"; not yet, because of https://github.com/swaywm/wlroots/issues/3189
  };
}
