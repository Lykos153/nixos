{ pkgs, ... }:
{
  home.packages = [
    (pkgs.kubectl.withKrewPlugins (plugins: with plugins; [
      node-shell
      get-all
      example
      cnpg
    ]))
    pkgs.kustomize
    pkgs.fluxcd
    pkgs.k9s
    pkgs.kubernetes-helm
  ];
  xdg.configFile."k9s/plugin.yml".source = ./k9s-plugin.yml;
}
