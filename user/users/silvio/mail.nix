{ config, lib, pkgs, ... }:

{
  programs.mbsync.enable = true;
  services.imapnotify.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };
  programs.neomutt = {
    enable = true;
    macros = [
      {
        map = [ "index" "pager" ];
        key = "\\cb";
        action = "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>"; #call urlscan to extract URLs out of a message
      }
      {
        map = [ "attach" "compose" ];
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
        boxes = [ "Inbox" "Uni" "Admin" ];
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
