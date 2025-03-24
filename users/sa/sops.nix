{config, ...}: {
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.keyFile = "${config.xdg.configHome}/age/home.key";
}
