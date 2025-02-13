{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.booq.securityKeys;
in {
  options.booq.securityKeys = {
    enable = lib.mkEnableOption "securityKeys";
    keyfile = lib.mkOption {
      type = lib.types.path;
    };
  };
  config = let
    keyfile = "Yubico/u2f_keys";
  in
    lib.mkIf cfg.enable {
      services.pcscd.enable = true;
      hardware.gpgSmartcards.enable = true;

      hardware.onlykey.enable = true;
      environment.systemPackages = [
        pkgs.onlykey
        pkgs.onlykey-cli
        pkgs.onlykey-agent
      ];
      services.upower.enable = true; # <- onlykey errors... but doesnt work anyway
      services.udev.packages = [pkgs.yubikey-personalization];
      security.pam = {
        u2f = {
          enable = false; # true would enable for all PAM, including ssh, see https://bytemeta.vip/repo/NixOS/nixpkgs/issues/166076

          settings = {
            # debug = true;
            # control = "required"; # Require password AND Yubikey
            cue = true; # show prompt
            origin = "pam://nixos-silvio";
            authFile = "/etc/${keyfile}";
          };
        };
        # Only enable Yubikey for the following services
        services.sudo.u2fAuth = true;
        services.su.u2fAuth = true;
        services.polkit-1.u2fAuth = true;
        # services.sshd.u2fAuth = false;
        # services.login.u2fAuth = false;
        # services.swaylock.u2fAuth = false;
      };
      environment.etc."${keyfile}".source = cfg.keyfile;
    };
}
