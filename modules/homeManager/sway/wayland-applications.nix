{pkgs, ...}: {
  programs.firefox.package = pkgs.firefox-wayland;
}
