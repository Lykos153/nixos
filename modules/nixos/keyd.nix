{
  lib,
  config,
  ...
}: let
  cfg = config.booq.keyd;
in {
  options.booq.keyd.enable = lib.mkEnableOption "keyd";
  config = lib.mkIf cfg.enable {
    services.keyd = {
      enable = true;
      keyboards = {
        microsoftSculpt = {
          ids = ["045e:07a5"];
          settings = {
            main = {
              # compose is menu key
              compose = "overload(meta,compose)";
            };
          };
        };
        thinkpad = {
          ids = ["0001:0001"];
          settings = {
            main = {
              # sysrq is print
              sysrq = "overload(meta,sysrq)";
            };
          };
        };
      };
    };
  };
}
