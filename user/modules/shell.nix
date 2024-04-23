{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
    settings = {
      workspaces = true;
      # search_mode_shell_up_key_binding = "prefix";
      # filter_mode_shell_up_key_binding = "session";
      history_filter = [
        "hvs\.[0-9a-f]+" # hashicorp vault tokens
      ];
    };
  };
  # fix https://github.com/atuinsh/atuin/pull/1913
  # can be removed when this fails
  programs.atuin.enableNushellIntegration = assert pkgs.atuin.version == "18.1.0"; false;
  programs.nushell = let
    cfg = config.programs.atuin;
    flagsStr = lib.escapeShellArgs cfg.flags;
  in {
    extraEnv = ''
      let atuin_cache = "${config.xdg.cacheHome}/atuin"
      if not ($atuin_cache | path exists) {
        mkdir $atuin_cache
      }
      ${cfg.package}/bin/atuin init nu ${flagsStr} | save --force ${config.xdg.cacheHome}/atuin/init.nu
    '';
    extraConfig = ''
      source ${config.xdg.cacheHome}/atuin/init.nu
    '';
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
