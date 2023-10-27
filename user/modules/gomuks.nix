{pkgs, ...}: {
  # TODO: Write a wrapper instead?
  home.shellAliases."gomuks" = "TMPDIR=\"/tmp/gomuks-$USER\" ${pkgs.gomuks}/bin/gomuks";
}
