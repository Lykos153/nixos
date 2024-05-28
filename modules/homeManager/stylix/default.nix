{
  pkgs,
  lib,
  config,
  ...
}:
with builtins;
  lib.mkIf (elem "stylix" (attrNames config)) {
    stylix.image = config.booq.lib.mkMyDefault ./black.png;
    stylix.autoEnable = config.booq.lib.mkMyDefault false;
  }
