{
  virtualisation.podman.enable = false;
  virtualisation.docker.enable = true;
  users.users.sa = {
    extraGroups = [ "docker" ];
  };
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/docker"
    ];
  };
}
