{
  config,
  pkgs,
  ...
}: {
  programs.nushell.extraConfig = ''
    use ${pkgs.repos.yk8s-nu} *
  '';
  xdg.configFile."yaook-k8s/env".source = ./env;
  xdg.configFile."yaook-k8s/envrc.local".source = ./envrc.local;
}
