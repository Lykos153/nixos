{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.fonts;
in {
  options.booq.fonts = {
    enable = lib.mkEnableOption "fonts";
  };
  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      roboto
      (pkgs.nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
      #google-fonts # google font collection (free)
      #lmodern # Latin Modern for non-latex applications
      #source-han-sans
      #source-han-serif # CJK fonts
    ];
  };
}
