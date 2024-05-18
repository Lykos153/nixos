{
  programs.zellij.enable = true;

  programs.nushell.extraConfig = ''
    if ( ((tty) | str starts-with "/dev/tty") and ((tty) != "/dev/tty1") ) {
      zellij
    }
  '';
}
