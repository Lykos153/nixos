{config, ...}: {
  programs.nushell = {
    enable = true;
    shellAliases = config.home.shellAliases;
    # configFile = ./config.nu;
    # envFile = ./env.nu;
    extraConfig = ''
      $env.config = {
        show_banner: false,
      }
    '';
  };
}
