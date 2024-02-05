{
  pkgs,
  lib,
  ...
}: {
  booq.lib.allowUnfreePackages = [
    "zoom"
  ];
  home.packages = with pkgs; [
    zoom-us
  ];
}
