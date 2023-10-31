{config, ...}: {
  imports = [
    ./completions.nix
  ];

  programs.nushell = {
    enable = true;
    shellAliases = config.home.shellAliases;
    # configFile = ./config.nu;
    # envFile = ./env.nu;
    extraConfig = ''
      $env.config = ($env | default {} config).config
      $env.config.show_banner = false
      source ${./keybindings.nu}
    '';
  };
}
