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
    boot.enableContainers =
      if lib.versionOlder config.system.stateVersion "22.05"
      then false
      else true;
  };
}
