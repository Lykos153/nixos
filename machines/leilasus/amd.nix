{
  pkgs,
  lib,
  ...
}: {
  hardware.opengl = {
    enable = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [libva];
    # setLdLibraryPath = true;
  };
}
