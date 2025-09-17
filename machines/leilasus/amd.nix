{
  pkgs,
  lib,
  ...
}: {
  hardware.graphics = {
    enable = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [libva];
  };
}
