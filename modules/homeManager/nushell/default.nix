{
  config,
  lib,
  ...
}: let
  cfg = config.booq.nushell;
in {
  imports = [
    ./completions.nix
  ];
  options.booq.nushell = {
    enable = lib.mkEnableOption "nushell";
  };
  config = lib.mkIf cfg.enable {
    booq.shell.enable = true;
    programs.nushell = {
      enable = true;
      shellAliases =
        config.home.shellAliases
        // {
          o = "open";
          l = "ls -l";
          la = "ls -a";
        };
      # configFile = ./config.nu;
      envFile.text = "";
      extraConfig = ''
        $env.config = ($env | default {} config).config
        $env.config.show_banner = false
        $env.config.ls.clickable_links = false
        source ${./keybindings.nu}
        use ${./functions.nu} *
        use ${./psub.nu}

        # Workaround for https://github.com/nix-community/home-manager/issues/4313
        if (("__HM_SESS_VARS_SOURCED" in $env) and ($env.__HM_SESS_VARS_SOURCED != "1")) {
          open ${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh | capture-foreign-env | load-env
        }
      '';
    };
    services.pueue.enable = true; # for background tasks
  };
}
