{config, ...}: {
  # sops.defaultSopsFile = ./secrets/default.yaml;
  sops.age.keyFile = "${config.xdg.configHome}/age/home.key";
}
