{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf (config.booq.audio == "pulseaudio") {
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
