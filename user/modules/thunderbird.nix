{
  config,
  lib,
  ...
}: {
  options.booq.thunderbird.enable = lib.mkEnableOption "mail";
  options.booq.thunderbird.commonSettings = lib.mkOption {
    default = {};
    type = lib.types.anything;
  };

  imports = [
  ];

  config = lib.mkIf config.booq.thunderbird.enable {
    booq.thunderbird.commonSettings = id: {
      "mail.identity.id_${id}.protectSubject" = false;
      "mail.identity.id_${id}.compose_html" = false;
      "mail.identity.id_${id}.attachPgpKey" = true;
      "mail.identity.id_${id}.reply_on_top" = 1;
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
  };
}
