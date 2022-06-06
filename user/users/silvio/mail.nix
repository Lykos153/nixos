{ config, lib, pkgs, ... }:

{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };

  accounts.email.accounts = {
    "booq" = {
      address = "silvio@booq.org";
      realName = "Silvio Ankermann";
      primary = true;
      imap.host = "imap.booq.org";
      smtp.host = "smtp.booq.org";
      userName = "silvio";
      notmuch.enable = true;

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        remove = "both";
        extraConfig.account = {
          authMechs = "PLAIN";
        };
      };
      passwordCommand = "pass booq/mail/silvio";

      msmtp = {
        enable = true;
      };
    };
  };
}
