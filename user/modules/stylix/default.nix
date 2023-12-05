{
  pkgs,
  lib,
  ...
}: {
  stylix.image = lib.mkDefault ./black.png;
  stylix.autoEnable = lib.mkDefault false;
}
