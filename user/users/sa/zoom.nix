{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "zoom"
    ];
  home.packages = with pkgs; [
    zoom-us
  ];
}
