{lib, ...}: {
  booq.gui.sway.enable = lib.mkForce true;
  booq.gui.xmonad.enable = lib.mkForce false;
}
