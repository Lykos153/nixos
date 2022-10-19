{pkgs, ...}:
{
  programs.git.userEmail = "silvio.ankermann@cloudandheat.com";
  programs.git.userName = "Silvio Ankermann";
  home.packages = with pkgs; [
    timewarrior
    rocketchat-desktop
    konversation
    mumble
  ];
  imports = [
    ./autostart.nix
    ./gui
  ];
}
