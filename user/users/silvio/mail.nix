{
  config,
  lib,
  pkgs,
  ...
}: {
  booq.mail.enable = true;

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
      imapnotify = {
        enable = true;
        boxes = ["Inbox" "Uni" "Admin"];
        #FIXME        onNotify = "${pkgs.notmuch}/bin/notmuch new;";
        onNotify = "true";
        onNotifyPost = "${pkgs.libnotify}/bin/notify-send 'New mail'";
      };
      passwordCommand = "${pkgs.pass}/bin/pass booq/mail/silvio";

      msmtp = {
        enable = true;
      };

      neomutt.enable = true;
    };
  };
}
