{
  options.booq.gui.enable = inputs.nixpkgs.lib.mkEnableOption "gui";
  options.booq.gui.sway.enable = inputs.nixpkgs.lib.mkEnableOption "sway";
}
