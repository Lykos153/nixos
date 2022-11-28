{ config, lib, pkgs, ... }:
lib.mkIf (config.booq.audio == "pipewire") {
  sound.enable = false;
  hardware.pulseaudio.enable = false;
}
