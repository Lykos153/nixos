{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.k8sAdmin;
in {
  options.booq.k8sAdmin = {
    enable = lib.mkEnableOption "k8sAdmin";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.kubectl.withKrewPlugins (plugins:
        with plugins; [
          node-shell
          get-all
          example
          cnpg
          rook-ceph
        ]))
      pkgs.kustomize
      pkgs.fluxcd
      pkgs.k9s
      pkgs.kubernetes-helm
    ];
    xdg.configFile."k9s/plugin.yml".source = ./k9s-plugin.yml;
  };
}
