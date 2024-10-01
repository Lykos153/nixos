{
  config,
  lib,
  ...
}: let
  cfg = config.booq.shell;
in {
  options.booq.shell = {
    enable = lib.mkEnableOption "shell";
  };
  config = lib.mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      flags = ["--disable-up-arrow"];
      settings = {
        workspaces = false;
        # search_mode_shell_up_key_binding = "prefix";
        # filter_mode_shell_up_key_binding = "session";
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
  };
}
