{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.booq.gui.enable {
    services.cbatticon.enable = true;
    services.cbatticon.batteryId = "BAT0";
    services.dunst.settings.cbatticon = {
      appname = "cbatticon";
      msg_urgency = "normal";
      override_dbus_timeout = 10;
    };
  };
}
