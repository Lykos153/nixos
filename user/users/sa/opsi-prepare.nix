{ pkgs, config, lib, ... }:
let
  # format = pkgs.formats.toml;
in
{
  home.activation.linkClusters = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf opsi-data/managed-k8s/cluster "$HOME/clusters"
  '';
  # home.file."clusters".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/opsi-data/managed-k8s/cluste";
  xdg.configFile."opsi-prepare/config.ini".text = ''
    [redmine]
    api_token_pass_path = redmine_token
  '';
}
