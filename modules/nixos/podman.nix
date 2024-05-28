{
  lib,
  config,
  ...
}: let
  cfg = config.booq.podman;
in {
  options.booq.podman = {
    enable = lib.mkEnableOption "podman";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = config.booq.lib.mkMyDefault true;
    virtualisation.podman.dockerCompat = true;
    boot.enableContainers = false; # TODO: Maybe set to true after migrating to state version 22.05
  };
}
