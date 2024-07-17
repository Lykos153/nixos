{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.booq.smartd;
in {
  options.booq.smartd = {
    enable = lib.mkEnableOption "smartd";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      smartmontools
    ];
    services.smartd = {
      enable = true;
      notifications.test = true;
      notifications.mail.enable = false;
      notifications.systembus-notify.enable = true;
    };
  };
}
