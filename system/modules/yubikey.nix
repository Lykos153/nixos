{ pkgs, ... }:
{
  ## Missing prompt issue: https://github.com/Yubico/yubico-pam/issues/208
  ## TODO: Maybe switch to https://github.com/Yubico/pam-u2f
  services.udev.packages = [ pkgs.yubikey-personalization ];
  security.pam = {
    yubico = {
      enable = false; # true would enable for all PAM, including ssh, see https://bytemeta.vip/repo/NixOS/nixpkgs/issues/166076

      debug = false;
      mode = "challenge-response";
      # control = "required"; # Require password AND Yubikey

      # chalresp_path = # TODO using sops-nix
    };
    # Only enable Yubikey for the following services
    services.login.yubicoAuth = true;
    services.swaylock.yubicoAuth = true;
    services.sudo.yubicoAuth = true;
  };
}
