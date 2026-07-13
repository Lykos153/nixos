{
  booq.gui.sway.enable = false;
  booq.gui.xmonad.enable = true;
  booq.gui.river.enable = true;
  booq.vscodium.useBlack = true;
  booq.jujutsu.enable = true;

  programs.git.settings.user.email = "silvio@booq.org";
  programs.git.settings.user.name = "Silvio Ankermann";
  programs.jujutsu.settings.user.name = "Silvio Ankermann";
  programs.jujutsu.settings.user.email = "silvio@booq.org";

  imports = [
    ./mail.nix
    ./sway
    ./sops.nix
    ./nushell.nix
    ./codeberg-cli
  ];
}
