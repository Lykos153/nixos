{
  virtualisation.podman.enable = false;
  virtualisation.docker.enable = true;
  users.users.sa = {
    extraGroups = ["docker"];
  };
  users.users.silvio = {
    extraGroups = ["docker"];
  };
  security.sudo.wheelNeedsPassword = false; # docker access means root anyway
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/docker"
    ];
  };
}
