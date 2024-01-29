{
  config,
  lib,
  pkgs,
  ...
}: {
  booq.thunderbird.enable = true;

  accounts.email.accounts = {
    "booq" = {
      address = "silvio@booq.org";
      realName = "Silvio Ankermann";
      primary = true;
      imap = {
        host = "imap.booq.org";
        tls.useStartTls = true;
      };
      smtp = {
        host = "smtp.booq.org";
        tls.useStartTls = true;
      };
      userName = "silvio";

      thunderbird = {
        enable = true;
        settings = config.booq.thunderbird.commonSettings;
      };
    };
  };
}
