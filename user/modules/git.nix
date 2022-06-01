{ config, lib, nixosConfig, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userEmail = "silvio@booq.org";
    userName = "Silvio Ankermann";
    aliases = {
      graph = "log --all --oneline --graph --decorate";
    };
    extraConfig = {
      push = {
        default = "simple";
        followtags  = true;
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  home.packages = [
    pkgs.pre-commit
  ];
}
