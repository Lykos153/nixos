{
  booq.gui.enable = true;
  booq.gui.sway.enable = false;
  programs.git.userEmail = "silvio@booq.org";
  programs.git.userName = "Silvio Ankermann";

  imports = [
    ./mail.nix
    ./sway
  ];
}
