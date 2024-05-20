{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: {
  options.booq.gui.i3.enable = lib.mkEnableOption "i3";
  config = lib.mkIf config.booq.gui.i3.enable {
    booq.gui.xorg.enable = true;
    xsession.windowManager.i3.enable = true;
  };
}
