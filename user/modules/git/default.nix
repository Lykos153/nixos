{ config, lib, nixosConfig, pkgs, ... }:
{
  imports = [ ./delta.nix ];

  programs.git = {
    enable = true;
    aliases = {
      graph = "log --all --oneline --graph --decorate";
      squash-all = "!f(){ git reset $(git commit-tree HEAD^{tree} -m \"$${1:-A new start}\");};f";
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
      merge.tool = "nvimdiff2";
    };
  };

  home.packages = [
    pkgs.pre-commit
  ];
}
