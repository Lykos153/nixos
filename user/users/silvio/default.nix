{
  booq.gui.enable = true;
  booq.gui.sway.enable = false;
  booq.gui.xmonad.enable = true;
  booq.talon.enable = true;
  programs.git.userEmail = "silvio@booq.org";
  programs.git.userName = "Silvio Ankermann";

  imports = [
    ./mail.nix
    ./sway
    ./sops.nix
    ./garden
  ];
}
