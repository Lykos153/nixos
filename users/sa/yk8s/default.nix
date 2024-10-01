{
  config,
  pkgs,
  ...
}: {
  programs.nushell.extraConfig = ''
    use ${pkgs.repos.yk8s-nu} *
    alias sshto = yk8s openstack ssh
    alias getip = yk8s openstack getip
    alias osl = yk8s openstack list
    alias osh = yk8s openstack show
  '';
  xdg.configFile."yaook-k8s/env".source = ./env;
  xdg.configFile."yaook-k8s/envrc.local".source = ./envrc.local;
}
