{pkgs, ...}: {
  programs.nushell.extraConfig = ''
    use ${./desec.nu} *
  '';
}
