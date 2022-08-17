{
  programs.git.userEmail = "silvio@booq.org";
  programs.git.userName = "Silvio Ankermann";

  imports = [
    ./mail.nix
    ./autostart.nix
    ./gui
  ];
}
