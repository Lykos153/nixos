{config, ...}: {
  xdg.configFile."yaook-k8s/env".source = ./env;
  xdg.configFile."yaook-k8s/envrc.local".source = ./envrc.local;
}
