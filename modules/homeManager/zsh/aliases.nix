{pkgs, ...}: {
  programs.zsh.shellAliases = {
    l = "${pkgs.lsd}/bin/lsd -l";
    lh = "${pkgs.lsd}/bin/lsd -lh";
    la = "${pkgs.lsd}/bin/lsd -la";
    tree = "${pkgs.lsd}/bin/lsd --tree";

    cal = "cal -3 --week --iso";
    dirs = "dirs -v";

    nix = "noglob nix";

    helpme = "remote-debug";
  };
}
