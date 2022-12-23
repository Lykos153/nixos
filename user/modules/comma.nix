{ pkgs, ... }:
{
  home.packages = [
    pkgs.comma
  ];
  programs.zsh.shellAliases."," = "comma";
}
