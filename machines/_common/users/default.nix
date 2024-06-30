{
  pkgs,
  config,
  ...
}: {
  imports = [./sops.nix];
  booq.users.enable = true;
  booq.securityKeys.keyfile = ./u2f_keys;
}
