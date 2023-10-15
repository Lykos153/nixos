{
  config,
  lib,
  pkgs,
  ...
}:
# TODO: move neomutt to subdir
# TODO: for each of the programs: only enable if it is enabled by at least one account
{
  options.booq.mail.enable = lib.mkEnableOption "mail";

  imports = [
    ./sidebar.nix
    ./html.nix
  ];

  config = lib.mkIf config.booq.mail.enable {
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
    };
  };
}
