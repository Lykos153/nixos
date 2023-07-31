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
  home.packages = with pkgs; [
    rocketchat-desktop
    konversation
    mumble
  ];
  imports = [
    ./autostart.nix
    ./calendar.nix
    ./gui
    ./zoom.nix
    ./zsh.nix
    ./mum-rs.nix
    ./sops.nix
    ./yk8s
  ];
}
