{pkgs, ...}: {
  imports = [
    ./annex.nix
  ];
  home.packages = with pkgs; [
    freecad
  ];
  booq.shared-repo.enable = true;
}
