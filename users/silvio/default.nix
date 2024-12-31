{
  booq.gui.sway.enable = false;
  booq.gui.xmonad.enable = true;
  booq.talon.enable = false;
  booq.vscode.useBlack = true;
  booq.jujutsu.enable = true;

  programs.git.userEmail = "silvio@booq.org";
  programs.git.userName = "Silvio Ankermann";
  programs.jujutsu.settings.user.name = "Silvio Ankermann";
  programs.jujutsu.settings.user.email = "silvio@booq.org";

  imports = [
    ./mail.nix
    ./sway
    ./sops.nix
    ./mutables
    ./nushell.nix
    ./codeberg-cli
  ];
}
