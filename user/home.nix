{ config, lib, nixosConfig, pkgs, ... }:
{
  imports = map (n: "${./modules}/${n}") (builtins.attrNames (builtins.readDir ./modules));

  home.username = "silvio";
  home.homeDirectory = "/home/silvio";
  
  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  programs.direnv.enable = true;
  programs.password-store.enable = true;

  programs.bat = {
    enable = true;
    config = {
      tabs = "4";
    };
  };

  home.packages = with pkgs; [
    vimPlugins.vim-plug
    termite
    vifm
    gajim
    htop
    thunderbird
    pwgen
    haskellPackages.git-annex
    jq
    element-desktop
    pavucontrol
    libreoffice
    nomacs
  ];

  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
    provider = "geoclue2";
    temperature.night = 3000;
    temperature.day = 5000;
  };

  home.sessionVariables = {
    # MOZ_ENABLE_WAYLAND = "1"; not yet, because of https://github.com/swaywm/wlroots/issues/3189
  };
}
