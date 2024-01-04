{
  config,
  lib,
  pkgs,
  ...
}: {
  booq.mail.enable = false;

  accounts.email.accounts = {
    cah = rec {
      address = "silvio.ankermann@cloudandheat.com";
      realName = "Silvio Ankermann";
      signature = {
        showSignature = "append";
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
      imap = {
        host = "mail.cloudandheat.com";
        tls.useStartTls = true;
      };
      smtp = {
        host = imap.host;
        tls.useStartTls = true;
      };
      userName = address;
      gpg = {
        key = "8D4762947205541C62A49C88F4226CA3971C4E97";
        signByDefault = true;
        encryptByDefault = true;
      };
      thunderbird = {
        enable = true;
        settings = id: {
          "mail.identity.id_${id}.protectSubject" = false;
          "mail.identity.id_${id}.compose_html" = false;
          "mail.identity.id_${id}.attachPgpKey" = true;
          "mail.identity.id_${id}.reply_on_top" = 1;
        };
      };
      passwordCommand = "${pkgs.pass}/bin/pass ldap";
    };
  };
  programs.thunderbird = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        withExternalGnupg = true;
        extraConfig = ''
          user_pref("mail.html_compose", false);
        '';
      };
    };
    settings = {
      "general.useragent.override" = "";
      "privacy.donottrackheader.enabled" = true;
    };
  };
}
