{ config, lib, pkgs, ... }:
lib.mkIf (config.booq.gui.enable && config.booq.gui.sway.enable) {
}
