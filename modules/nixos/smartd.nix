{
  lib,
  config,
  ...
}: let
  cfg = config.booq.smartd;
in {
  options.booq.smartd = {
    enable = lib.mkEnableOption "smartd";
  };
  config = lib.mkIf cfg.enable {
    services.smartd = {
      enable = true;
      notifications.test = true;
      notifications.mail.enable = false;
    };
  };
}
