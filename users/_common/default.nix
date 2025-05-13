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
    ./gpg/0F264CB39D5204DFF661EEBCFCC69E84E280E96F.gpg
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
    # TODO currently broken
    # lykos153.garden
    rclone
    ripgrep
    ripgrep-all # search in docs, pdfs etc.
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

    openssl

    json2nix
    yaml2nix
    toml2nix

    tectonic
    nixfmt-rfc-style

    gimp
  ];

  home = {
    stateVersion = "22.05";
  };
}
