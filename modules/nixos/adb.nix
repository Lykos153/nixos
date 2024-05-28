{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.booq.adb;
in {
  options.booq.adb = {
    enable = lib.mkEnableOption "adb";
  };
  config = lib.mkIf cfg.enable {
    services.udev.packages = [
      pkgs.android-udev-rules
    ];
  };
}
