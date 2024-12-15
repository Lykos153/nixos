{lib, ...}: {
  booq.gui.sway.enable = lib.mkForce true;
  booq.gui.xmonad.enable = lib.mkForce false;
  booq.gui.river.enable = true;
}
