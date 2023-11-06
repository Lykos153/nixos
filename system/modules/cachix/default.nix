# WARN: this file will get overwritten by $ cachix use <name>
{
  pkgs,
  lib,
  config,
  ...
}: let
  folder = ./substituters;
  toImport = name: value: folder + ("/" + name);
  filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key;
  imports = lib.mapAttrsToList toImport (lib.filterAttrs filterCaches (builtins.readDir folder));
in {
  inherit imports;
  nix.settings.substituters = ["https://cache.nixos.org/"];

  sops.secrets."cachix.dhall" = {
    name = "cachix.dhall";
    key = "cachix.dhall";
    sopsFile = ./secrets.yaml;
  };

  systemd.services.cachix-watch-store = lib.mkIf config.booq.sops.enable {
    description = "Cachix store watcher service";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    path = [config.nix.package];
    environment.XDG_CACHE_HOME = "/var/cache/cachix-watch-store";
    serviceConfig = {
      Restart = "always";
      CacheDirectory = "cachix-watch-store";
      ExecStart = "${pkgs.cachix}/bin/cachix watch-store lykos153";
    };
  };
}
