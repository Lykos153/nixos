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

    # gui applications
    termite
    gajim
    thunderbird
    element-desktop
    pavucontrol
    libreoffice
    nomacs
    okular-x11
    mate.caja
    vlc
  ];

  services.udiskie.enable = true;

  home.sessionVariables = {
    # MOZ_ENABLE_WAYLAND = "1"; not yet, because of https://github.com/swaywm/wlroots/issues/3189
  };
}
