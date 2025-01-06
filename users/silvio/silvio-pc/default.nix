{pkgs, ...}: {
  home.packages = with pkgs; [
    freecad
  ];
  booq.shared-repo.enable = true;
}
