{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [./securityKeys.nix];

  security.sudo-rs.enable = true;
  security.sudo-rs.wheelNeedsPassword = config.security.sudo.wheelNeedsPassword;
}
