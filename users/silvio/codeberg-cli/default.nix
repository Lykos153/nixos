{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    codeberg-cli
  ];
  sops.secrets.codeberg-token.sopsFile = ./secrets.yaml;
  xdg.dataFile.".berg-cli/TOKEN".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/sops-nix/secrets/codeberg-token";
}
