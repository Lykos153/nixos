{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: {
  imports = [
    ./delta.nix
    ./difftastic.nix
  ];

  programs.git = {
    enable = true;
    aliases = {
      graph = "log --all --oneline --graph --decorate";
      squash-all = "!f(){ git reset $(git commit-tree HEAD^{tree} -m \"$${1:-A new start}\");};f";
      rbi = "rebase -i";
      fpush = "push --force-with-lease";
      amend = "commit --amend --no-edit";
    };
    extraConfig = {
      push = {
        default = "simple";
        followtags = true;
        # useForceIfIncludes = true;
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
      rebase = {
        autosquash = true;
        autostash = true;
      };
      merge.tool = "kdiff3";
    };
  };

  programs.gitui.enable = true;

  home.shellAliases = {
    g = "git";
    gst = "git status";
    gd = "git diff";
    gsh = "git show";
    gc = "git commit";
    gca = "git commit --amend --no-edit";
    grb = "git rebase";
    gg = "gitui";
    ga = "git annex";
  };

  home.packages = with pkgs; [
    pre-commit
    kdiff3
    git-absorb
    git-remote-gcrypt
    git-annex
    git-annex-remote-googledrive
    tig
    tea
    glab
    gh
    ghq
  ];
}
