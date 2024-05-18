{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };
}
