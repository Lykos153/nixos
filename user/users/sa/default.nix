{pkgs, ...}:
{

  booq.gui.enable = true;
  booq.gui.sway.enable = false;
  booq.gui.xmonad.enable = true;

  programs.git.userEmail = "silvio.ankermann@cloudandheat.com";
  programs.git.userName = "Silvio Ankermann";
  programs.ssh.extraConfig = ''
      User silvioankermann
    '';
  home.sessionVariables.MANAGED_K8S_SSH_USER = "silvioankermann";
  home.packages = with pkgs; [
    timewarrior
    rocketchat-desktop
    konversation
    mumble
  ];
  imports = [
    ./autostart.nix
    ./calendar.nix
    ./gui
    ./gpg
    ./zoom.nix
    ./zsh.nix
    ./mum-rs.nix
  ];
}
