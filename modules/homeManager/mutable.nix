{lib, ...}: {
  options.booq.mutableFlakeDir = lib.mkOption {
    type = with lib.types; nullOr path;
    default = "/etc/nixos";
  };
}
