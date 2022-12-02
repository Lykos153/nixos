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
  programs.firefox.package = pkgs.firefox-wayland;
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
    git-absorb
    git-remote-gcrypt
    git-annex
    git-annex-remote-googledrive
    tig
    jq
    yq
    mr
    ripgrep
    ripgrep-all # search in docs, pdfs etc.
    fd # simpler find
    ncdu
    python3Packages.ipython
    screen
    pv
    unzip
    moreutils
    ranger
    tldr
    lsd # new ls

    # gui applications
    termite
    gajim
    thunderbird
    schildichat-desktop
    pavucontrol
    libreoffice
    nomacs
    okular-x11
    xfce.thunar
    vlc
    system-config-printer
  ];

  services.udiskie.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  home.sessionVariables = {
    # MOZ_ENABLE_WAYLAND = "1"; not yet, because of https://github.com/swaywm/wlroots/issues/3189
  };
}
