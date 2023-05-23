{ pkgs, ...}:
{
  # TODO: if shell == zsh
  programs.zsh.shellAliases."gomuks" = "TMPDIR=\"/tmp/gomuks-$USER\" ${pkgs.gomuks}/bin/gomuks";
}
