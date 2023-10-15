{config, ...}: let
  justfilePath = "yaook-k8s/Justfile";
in {
  xdg.configFile."yaook-k8s/env".source = ./env;
  xdg.configFile."yaook-k8s/envrc.local".source = ./envrc.local;
  xdg.configFile."${justfilePath}".source = ./Justfile;
  programs.zsh = {
    shellAliases = {
      yk8s = "just --working-directory . --justfile ${config.xdg.configHome}/${justfilePath}";
    };
  };
}
