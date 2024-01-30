{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: {
  imports = map (n: "${./modules}/${n}") (builtins.attrNames (builtins.readDir ./modules));

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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

    poetry
    just

    lykos153.shrinkpdf
    lykos153.git-rstash
    lykos153.cb
    feh
  ];
}
