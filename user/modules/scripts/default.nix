{
  config,
  lib,
  pkgs,
  ...
}: let
  rga-fzf = pkgs.writeShellApplication {
    name = "rga-fzf";

    runtimeInputs = [pkgs.ripgrep-all pkgs.fzf];

    text = builtins.readFile ./bin/rga-fzf;
  };
  zsh_history_fix = pkgs.writeShellApplication {
    name = "zsh_history_fix";

    runtimeInputs = [pkgs.binutils];

    text = builtins.readFile ./bin/zsh_history_fix;
  };
  list-iommu-groups = pkgs.writeShellApplication {
    name = "list-iommu-groups";

    runtimeInputs = [pkgs.pciutils];

    text = builtins.readFile ./bin/list-iommu-groups;
  };
in {
  home.packages = [
    rga-fzf
    zsh_history_fix
    list-iommu-groups
  ];
}
