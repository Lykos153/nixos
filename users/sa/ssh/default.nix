{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkMerge (builtins.map (v: let
  k = "${v}.known_hosts";
in {
  sops.secrets.${v}.sopsFile = ./secrets.yaml;
  sops.secrets.${k}.sopsFile = ./secrets.yaml;
  home.file.".ssh/config.d/${v}".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/sops-nix/secrets/${v}";
  home.file.".ssh/${k}".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/sops-nix/secrets/${k}";
  booq.ssh.extraKnownHostsFiles = ["~/.ssh/${k}"];
}) ["l1" "ch"])
