{lib, ...}: {
  imports = [
    ./unfree.nix
  ];
  options.booq.lib.mkMyDefault = lib.mkOption {
    default = {};
    type = lib.types.anything;
  };
  config.booq.lib.mkMyDefault = lib.mkOverride 500;
}
