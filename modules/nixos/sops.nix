{
  lib,
  config,
  ...
}: {
  options.booq.sops.enable = lib.mkEnableOption "sops";
}
