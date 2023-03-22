{ config, lib, nixosConfig, pkgs, ... }:
lib.mkIf (config.booq.gui.enable && config.booq.gui.i3.enable) {
  booq.gui.xorg.enable = true;
  xsession.windowManager.i3.enable = true;
}
