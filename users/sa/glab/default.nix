{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    glab
  ];
  sops.secrets.glab-config.sopsFile = ./secrets.yaml;
  sops.secrets.glab-config.mode = "0600";
  xdg.configFile."glab-cli/config.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/sops-nix/secrets/glab-config";
  programs.nushell.extraConfig = ''
    def --wrapped chlab [...args] {
      GL_HOST=gitlab.cloudandheat.com glab ...$args
    }
  '';
}
