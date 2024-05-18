{
  config,
  pkgs,
  ...
}: {
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
}
