{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: {
  booq.full.enable = true;
  booq.gpg.myPubKeys = [
    ./gpg/8D4762947205541C62A49C88F4226CA3971C4E97.gpg
    ./gpg/A63BA766.gpg
  ];

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

  programs.gh.enable = true;

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
    lykos153.garden
    ripgrep
    # TODO currently broken
    # ripgrep-all # search in docs, pdfs etc.
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
    profanity
    pulsemixer
    termdown

    poetry
    just

    lykos153.shrinkpdf
    lykos153.git-rstash
  ];

  home = {
    stateVersion = "22.05";
  };
}
