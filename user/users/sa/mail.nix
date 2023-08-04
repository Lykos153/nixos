{ config, lib, pkgs, ... }:

{
  booq.mail.enable = true;

  accounts.email.accounts =
  let
    address = "silvio.ankermann@cloudandheat.com";
    host = "mail.cloudandheat.com";
  in
  {
    "booq" = {
      address = address;
      realName = "Silvio Ankermann";
      primary = true;
      imap.host = host;
      smtp.host = host;
      userName = address;
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
      imapnotify = {
        enable = true;
        boxes = [ "Inbox" "Git" "Support" ];
#FIXME        onNotify = "${pkgs.notmuch}/bin/notmuch new;";
        onNotify = "true";
        onNotifyPost = "${pkgs.libnotify}/bin/notify-send 'New mail'";
      };
      passwordCommand = "${pkgs.pass}/bin/pass ldap";

      msmtp = {
        enable = true;
      };

      neomutt.enable = true;
    };
  };
}
