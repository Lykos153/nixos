{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.booq.cliMail.enable {
    programs.neomutt = {
      binds = [
        {
          map = ["index" "pager"];
          key = "\\CP";
          action = "sidebar-prev";
        }
        {
          map = ["index" "pager"];
          key = "\\CN";
          action = "sidebar-next";
        }
        {
          map = ["index" "pager"];
          key = "\\CO";
          action = "sidebar-open";
        }
      ];
      extraConfig = ''
        set sidebar_visible
        set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
        set mail_check_stats
      '';
    };
  };
}
