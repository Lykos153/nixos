{
  pkgs,
  lib,
  config,
  ...
}: (builtins.foldl' (acc: v:
    lib.attrsets.recursiveUpdate acc {
      sops.secrets.${v}.sopsFile = ./secrets.yaml;
      sops.secrets."${v}.known_hosts".sopsFile = ./secrets.yaml;
      home.file.".ssh/config.d/${v}".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/sops-nix/secrets/${v}";
      home.file.".ssh/${v}.known_hosts".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/sops-nix/secrets/${v}.known_hosts";
      booq.ssh.extraKnownHostsFiles = [".ssh/${v}.known_hosts"];
    }) {} ["l1" "ch"])
