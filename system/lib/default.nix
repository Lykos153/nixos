{lib, ...}: {
  options.booq.lib = lib.mkOption {
    default = {};
    type = lib.types.anything;
  };
  config.booq.lib = {
    mkMyDefault = lib.mkOverride 500;
  };
}