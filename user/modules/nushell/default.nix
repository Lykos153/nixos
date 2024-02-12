{config, ...}: {
  imports = [
    ./completions.nix
  ];

  programs.nushell = {
    enable = true;
    shellAliases =
      config.home.shellAliases
      // {
        o = "open";
      };
    # configFile = ./config.nu;
    envFile.text = "";
    extraConfig = ''
      $env.config = ($env | default {} config).config
      $env.config.show_banner = false
      source ${./keybindings.nu}
      use ${./functions.nu} *
    '';
  };
}
