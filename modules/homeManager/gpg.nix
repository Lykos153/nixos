{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: let
  cfg = config.booq.gpg;
in {
  options.booq.gpg = {
    enable = lib.mkEnableOption "gpg";
    myPubKeys = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.path;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      settings = {
        keyserver = "hkp://keys.gnupg.net";
      };
      scdaemonSettings = {
        disable-ccid = true;
      };
      publicKeys = let
        mkPubkey = key: {
          source = key;
          trust = 5;
        };
      in
        builtins.map mkPubkey cfg.myPubKeys;
    };

    services.gpg-agent = {
      enable = true;

      defaultCacheTtl = 86400;
      defaultCacheTtlSsh = 86400;
      maxCacheTtl = 86400;
      maxCacheTtlSsh = 86400;
      enableSshSupport = true;
      extraConfig =
        ''
          pinentry-program ${pkgs.pinentry-qt}/bin/pinentry
        ''
        + ''
          allow-loopback-pinentry
        '';
    };
  };
}
