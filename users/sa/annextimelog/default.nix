{pkgs, ...}: {
  home.packages = with pkgs; [
    annextimelog
  ];
  programs.nushell.extraConfig = ''
    use ${./annextimelog.nu} *
  '';
}
