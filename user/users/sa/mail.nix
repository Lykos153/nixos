{
  config,
  lib,
  pkgs,
  ...
}: {
  booq.mail.enable = true;

  accounts.email.accounts = let
    address = "silvio.ankermann@cloudandheat.com";
    host = "mail.cloudandheat.com";
  in {
    cah = {
      address = address;
      realName = "Silvio Ankermann";
      signature = {
        text = ''
          Silvio Ankermann
          DevOps Engineer

          Cloud&Heat Technologies GmbH
          Königsbrücker Straße 96 | 01099 Dresden
          +49 351 479 367 00
          Silvio.Ankermann@cloudandheat.com | www.cloudandheat.com

          Green, Open, Efficient.
          Your Cloud Service und Cloud Technology Provider from Dresden.
          https://www.cloudandheat.com/

          Commercial Register: District Court Dresden
          Register Number: HRB 30549
          VAT ID No.: DE281093504
          Managing Director: Nicolas Röhrs
          Authorized signatory: Dr. Marius Feldmann
        '';
      };
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
      thunderbird.enable = true;
      imapnotify = {
        enable = true;
        boxes = ["Inbox" "Git" "Support"];
        #FIXME        onNotify = "${pkgs.notmuch}/bin/notmuch new;";
        onNotify = "true";
        onNotifyPost = "${pkgs.libnotify}/bin/notify-send 'New mail'";
      };
      passwordCommand = "${pkgs.pass}/bin/pass ldap";

      msmtp = {
        enable = true;
      };

      neomutt = {
        enable = true;
        extraMailboxes = [
          "Drafts"
          "Sent"
          "Git"
          "Support"
        ];
      };
    };
  };
  programs.thunderbird = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
      };
    };
  };
}
