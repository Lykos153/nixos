{
  lib,
  pkgs,
  ...
}: {
  booq.audio.backend = "pipewire";
  musnix = {
    enable = true;
    kernel.realtime = true;
    kernel.packages = pkgs.linuxPackages_latest;
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
