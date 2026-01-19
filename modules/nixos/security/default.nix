{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [./securityKeys.nix];

  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  security.sudo-rs.enable = true;
  security.sudo-rs.wheelNeedsPassword = config.security.sudo.wheelNeedsPassword;
}
