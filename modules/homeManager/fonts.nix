{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    roboto
    (pkgs.nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
    #google-fonts # google font collection (free)
    #lmodern # Latin Modern for non-latex applications
    #source-han-sans
    #source-han-serif # CJK fonts
  ];
}
