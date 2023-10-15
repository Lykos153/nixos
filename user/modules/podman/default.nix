{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: {
  xdg.configFile."containers/registries.conf".source = ./registries.conf;
}
