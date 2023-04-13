{ config, lib, nixosConfig, pkgs, ... }:
let
  icomoon-feather = pkgs.callPackage ./icomoon-feather.nix { };
in
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    roboto
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    icomoon-feather
    #google-fonts # google font collection (free)
    #lmodern # Latin Modern for non-latex applications
    #source-han-sans
    #source-han-serif # CJK fonts
  ];
}
