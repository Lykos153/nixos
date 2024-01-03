{
  config,
  lib,
  pkgs,
  ...
}: {
  booq.mail.enable = false;

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
      imap = {
        host = host;
        tls.useStartTls = true;
      };
      smtp = {
        host = host;
        tls.useStartTls = true;
      };
      userName = address;
      gpg = {
        key = "0xF4226CA3971C4E97";
        signByDefault = true;
        encryptByDefault = true;
      };
      thunderbird = {
        enable = true;
        settings = id: {
          "mail.identity.id_${id}.protectSubject" = false;
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
      };
    };
  };
}
