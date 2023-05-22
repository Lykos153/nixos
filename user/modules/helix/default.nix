{ pkgs, ... }:
{
  home.packages = [
    pkgs.helix
  ];
  xdg.configFile."helix/config.toml".source = ./config.toml;
}
