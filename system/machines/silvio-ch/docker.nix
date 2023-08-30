{
  virtualisation.podman.enable = false;
  virtualisation.docker.enable = true;
  users.users.sa = {
    extraGroups = [ "docker" ];
  };
}
