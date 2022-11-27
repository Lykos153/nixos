{
  booq.gui.enable = true;
  booq.gui.sway.enable = true;
  programs.git.userEmail = "silvio@booq.org";
  programs.git.userName = "Silvio Ankermann";

  imports = [
    ./mail.nix
    ./sway
  ];
}
