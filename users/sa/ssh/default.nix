{
  pkgs,
  lib,
  config,
  ...
}: let
  l1_known_hosts = ".ssh/l1.known_hosts";
in {
  sops.secrets.l1.sopsFile = ./secrets.yaml;
  home.file.".ssh/config.d/l1".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/sops-nix/secrets/l1";

  sops.secrets."l1.known_hosts".sopsFile = ./secrets.yaml;
  booq.ssh.extraKnownHostsFiles = ["~/${l1_known_hosts}"];
  home.file."${l1_known_hosts}".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/sops-nix/secrets/l1.known_hosts";
}
