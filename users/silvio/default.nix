{
  booq.gui.sway.enable = false;
  booq.gui.xmonad.enable = true;
  booq.talon.enable = true;
  booq.vscode.useBlack = true;

  programs.git.userEmail = "silvio@booq.org";
  programs.git.userName = "Silvio Ankermann";

  imports = [
    ./mail.nix
    ./sway
    ./sops.nix
    ./mutables
    ./nushell.nix
  ];
}
