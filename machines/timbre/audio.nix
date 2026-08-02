{
  lib,
  pkgs,
  ...
}: {
  booq.audio.backend = "pipewire";
  musnix = {
    enable = true;
    rtirq.enable = true;
    das_watchdog.enable = true;

    ffado.enable = true;
  };
  environment.systemPackages = with pkgs; [
    ardour
    lmms
    non
    qtractor
    rosegarden
  ];
}
