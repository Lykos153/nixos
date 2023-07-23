{ pkgs, ... }:
{
  home.packages = [
    (pkgs.kubectl.withKrewPlugins (plugins: [
      plugins.node-shell
      plugins.get-all
    ]))
    pkgs.k9s
    pkgs.kubernetes-helm
  ];
  xdg.configFile."k9s/plugin.yml".source = ./k9s-plugin.yml;
}
