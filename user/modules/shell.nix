{
  programs.atuin.enable = true;
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd=cd"
    ];
  };
  programs.starship = {
    enable = true;
    settings = {
      git_commit.tag_disabled = false;
    };
  };
  home.shellAliases = {
    ip = "ip --color=auto";
    l = "lsd -l";
    lh = "lsd -lh";
    la = "lsd -la";
    tree = "lsd --tree";

    r = "ranger";

    os = "openstack";
    k = "kubectl";

    rsynca = "rsync -avPhL --append";
    dd = "dd status=progress";

    findnix = "nix search nixpkgs";

    suspend = "systemctl -i suspend";
    hibernate = "systemctl -i hibernate";

    sido = "sudo -i";
  };
}
