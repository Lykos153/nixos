{localFlake}: {
  imports = [
    localFlake.colmena-flake.flakeModules.default
  ];

  colmena-flake.deployment.timbre = {
    targetHost = "192.168.2.219";
    targetUser = "silvio";
    tags = [];
  };
}
