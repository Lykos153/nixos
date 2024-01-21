{
  lib,
  config,
  ...
}: {
  virtualisation.podman.enable = config.booq.lib.mkMyDefault true;
  virtualisation.podman.dockerCompat = true;
  boot.enableContainers = false; # TODO: Maybe set to true after migrating to state version 22.05
}
