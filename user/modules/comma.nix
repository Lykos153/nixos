{pkgs, ...}: {
  home.packages = [
    pkgs.comma
  ];
  home.shellAliases."," = "comma";
}
