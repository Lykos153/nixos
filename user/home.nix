{ config, lib, nixosConfig, pkgs, ... }:
{
  imports = map (n: "${./modules}/${n}") (builtins.attrNames (builtins.readDir ./modules));

  home.username = "silvio";
  home.homeDirectory = "/home/silvio";
  
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
    #cli applications
    vimPlugins.vim-plug
    vifm
    htop
    pwgen
    git
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

    # gui applications
    termite
    gajim
    thunderbird
    element-desktop
    pavucontrol
    libreoffice
    nomacs
    okular
    mate.caja
    vlc
  ];

  services.udiskie.enable = true;

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  home.sessionVariables = {
    # MOZ_ENABLE_WAYLAND = "1"; not yet, because of https://github.com/swaywm/wlroots/issues/3189
  };
}
