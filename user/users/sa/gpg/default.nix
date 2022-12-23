{ pkgs, ... }:
{
  programs.gpg = {
    # settings = {
    #   keyserver = "hkp://keys.gnupg.net";
    # };
    publicKeys = [
      {
        source = ./pubkeys/8D4762947205541C62A49C88F4226CA3971C4E97.gpg;
        trust = 5;
      }
    ];
  };
}
