{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.booq.nix-ld;
in {
  options.booq.nix-ld.enable = lib.mkEnableOption "nix-ld";
  config = lib.mkIf cfg.enable {
    programs.nix-ld.enable = true;

    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
    ];
  };
}
