{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.booq.mail.enable {
    programs.neomutt = {
      macros = [
        {
          map = ["index" "pager"];
          key = "\\cb";
          action = "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>"; #call urlscan to extract URLs out of a message
        }
        {
          map = ["attach" "compose"];
          key = "\\cb";
          action = "<pipe-entry> ${pkgs.urlscan}/bin/urlscan<Enter>"; #call urlscan to extract URLs out of a message
        }
      ];
      extraConfig = ''
        auto_view text/html
        set mailcap_path = ${config.xdg.configHome + "/neomutt/mailcap"}
      '';
    };
    xdg.configFile."neomutt/mailcap".text = ''
      text/html; ${pkgs.firefox}/bin/firefox %s;
      text/html; ${pkgs.lynx}/bin/lynx -assume_charset=%{charset} -display_charset=utf-8 -dump %s; nametemplate=%s.html; copiousoutput
    '';
  };
}
