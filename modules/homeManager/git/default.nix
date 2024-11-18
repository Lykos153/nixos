{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.git;
in {
  imports = [
    ./delta.nix
    ./difftastic.nix
    ./mergiraf.nix
  ];
  options.booq.git = {
    enable = lib.mkEnableOption "git";
  };
  config = lib.mkIf cfg.enable {
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
          autoSetupRemote = true;
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
        rerere.enabled = true;
      };
    };

    programs.lazygit = {
      enable = true;
      settings = {
        git.overrideGpg = true;
      };
    };

    home.shellAliases = {
      g = "git";
      gst = "git status";
      gd = "git diff";
      gsh = "git show";
      gc = "git commit";
      gca = "git commit --amend --no-edit";
      grb = "git rebase";
      gg = "lazygit";
      ga = "git annex";
    };

    home.packages = with pkgs; [
      pre-commit
      kdiff3
      git-absorb
      git-remote-gcrypt
      git-annex
      yt-dlp # for git-annex addurl
      tig
      tea
      glab
      gh
      ghq
    ];
  };
}
