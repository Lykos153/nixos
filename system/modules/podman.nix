{ lib, ... }:
{
  virtualisation.podman.enable = lib.mkDefault true;
  virtualisation.podman.dockerCompat = true;
  boot.enableContainers = false; # TODO: Maybe set to true after migrating to state version 22.05
}
