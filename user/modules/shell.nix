{
  programs.atuin = {
    enable = true;
    settings = {
      workspaces = true;
      history_filter = [
        "hvs\.[0-9a-f]+" # hashicorp vault tokens
      ];
    };
  };
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd=cd"
    ];
  };
  programs.starship = {
    enable = false;
    settings = {
      git_commit.tag_disabled = false;
    };
  };
  programs.oh-my-posh = {
    enable = true;
    useTheme = "blue-owl";
  };
  home.shellAliases = {
    ip = "ip --color=auto";

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
