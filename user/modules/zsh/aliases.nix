{
  programs.zsh.shellAliases = {
    ip  = "ip --color=auto";
    ls = "lsd";
    l   = "lsd -l";
    lh  = "lsd -lh";
    la  = "lsd -la";
    tree = "lsd --tree";

    n      = "$TERM&!";

    os  = "openstack";
    k   = "kubectl";

    cal = "cal -3 --week --iso";
    dirs    = "dirs -v";
    rsynca  = "rsync -avPhL --append";
    dd      = "dd status=progress";

    g   = "git";
    gst = "git status";
    gd  = "git diff";
    gsh = "git show";
    gc  = "git commit";
    gca  = "git commit --amend --no-edit";
    grb = "git rebase";
    gg  = "gitui";
    ga  = "git annex";

    hmb = "_hm_nix_build_switch build user";
    hms = "_hm_nix_build_switch switch user";
    renix = "_hm_nix_build_switch switch system";
    testnix = "_hm_nix_build_switch test system";
    nix = "noglob nix";
    findnix = "nix search nixpkgs";
    nownix = "nsh";

    helpme = "remote-debug";

    manix = "nix run 'github:mlvzk/manix' --"; # too big to be installed by default. Rather only pull it when needed
  };
}
