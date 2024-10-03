{
  lib,
  options,
  config,
  ...
}: let
  cfg = config.booq.ddns;
in {
  options.booq.ddns = {
    enable = lib.mkEnableOption "ddns";
    sopsFile = lib.mkOption {
      type = lib.types.path;
    };
    secretName = lib.mkOption {
      default = "ddns.json";
      type = lib.types.str;
    };
    serviceName = lib.mkOption {
      default = "ddns-updater";
      type = lib.types.str;
    };
    resolverAddress = lib.mkOption {
      default = "[2606:4700:4700::1111]:53";
      type = lib.types.str;
    };
    publicIpFetchers = lib.mkOption {
      default = "dns";
      type = lib.types.commas;
    };
  };
  config = lib.mkIf cfg.enable (
    {
      services.${cfg.serviceName} = {
        enable = true;
        environment = {
          CONFIG_FILEPATH = "/run/credentials/${cfg.serviceName}.service/${cfg.secretName}";
          RESOLVER_ADDRESS = cfg.resolverAddress;
          PUBLICIP_FETCHERS = cfg.publicIpFetchers;
        };
      };
      systemd.services.${cfg.serviceName}.serviceConfig.LoadCredential = "${cfg.secretName}:${config.sops.secrets.${cfg.secretName}.path}";
    }
    // (
      if (options ? "sops" && config.booq.sops.enable)
      then {
        sops.secrets.${cfg.secretName}.sopsFile = cfg.sopsFile;
      }
      else {
        warnings = ["ddns is enabled but sops is not."];
      }
    )
  );
}
