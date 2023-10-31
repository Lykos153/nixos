{
  pkgs,
  lib,
  ...
}: {
  hardware.opengl = {
    enable = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [libva];
    setLdLibraryPath = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-run"
      "steam-original"
      "steam-runtime"
    ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
