{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.pass;
in {
  options.booq.pass = {
    enable = lib.mkEnableOption "pass";
  };
  config = lib.mkIf cfg.enable {
    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
    };
    programs.rofi.pass = {
      enable = true;
      stores = [
        config.programs.password-store.settings.PASSWORD_STORE_DIR
      ];
      extraConfig = ''
        help_color="#4872FF"
      '';
    };
    services.pass-secret-service = {
      enable = false;
      storePath = config.programs.password-store.settings.PASSWORD_STORE_DIR;
    };

    programs.zsh.initExtra = ''
      pass_pop() {
        local codepath="$1"
        pass show "$codepath" | head -n1 | cb
        pass show "$codepath" | tail -n+2 | pass insert -fm "$codepath" > /dev/null
        echo "$(pass show "$codepath" | wc -l) entries left"
      }
    '';
  };
}
