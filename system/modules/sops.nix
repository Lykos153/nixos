{ lib, config, ... }:
{
  options.booq.sops.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };
  config = lib.mkIf config.booq.sops.enable {
    sops.defaultSopsFile = ./.secrets.yaml;
  };
}
