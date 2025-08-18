{
  config,
  lib,
  ...
}:
# TODO: depend on booq.gui.wayland
lib.mkIf config.booq.gui.river.enable {
  services.kanshi = {
    enable = true;
  };
}
