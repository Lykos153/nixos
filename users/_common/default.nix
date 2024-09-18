{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: {
  booq.full.enable = true;

  home.keyboard.layout = "de";

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  services.gnome-keyring.enable = true;

  programs.bat = {
    enable = true;
    config = {
      tabs = "4";
    };
  };

  programs.zellij.enable = true;
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
  ];
}
