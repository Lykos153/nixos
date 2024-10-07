{
  config,
  lib,
  ...
}: {
  options.booq.thunderbird.enable = lib.mkEnableOption "mail";
  options.booq.thunderbird.commonSettings = lib.mkOption {
    default = id: {
      "mail.identity.id_${id}.protectSubject" = false;
      "mail.identity.id_${id}.compose_html" = false;
      "mail.identity.id_${id}.attachPgpKey" = true;
      "mail.identity.id_${id}.reply_on_top" = 1;
    };
    type = lib.types.functionTo lib.types.attrs;
  };

  config = lib.mkIf config.booq.thunderbird.enable {
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
        "mail.strictly_mime" = true; # To avoid utf-8 mojibake with gpupg encrypted mails
      };
    };
    xdg.mimeApps.associations.added = {
      "x-scheme-handler/mailto" = "thunderbird.desktop";
    };
  };
}
