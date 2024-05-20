{
  config,
  lib,
  ...
}: let
  cfg = config.booq.podman;
in {
  options.booq.podman = {
    enable = lib.mkEnableOption "podman";
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile."containers/registries.conf".source = ./registries.conf;
  };
}
