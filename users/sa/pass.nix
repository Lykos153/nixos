{
  config,
  lib,
  pkgs,
  ...
}: let
  opassDir = "${config.home.homeDirectory}/opsi-data/opsi-pass";
  aopassDir = "${config.home.homeDirectory}/opsi-data/aoterra_admin_passwords";
in {
  programs.rofi.pass.stores = [opassDir aopassDir];
  programs.zsh = {
    shellAliases = {
      opass = "PASSWORD_STORE_DIR=${opassDir} PASSWORD_STORE_GPG_OPTS=--options ${opassDir}/gpg-groups.conf --trust-model always pass";
      aopass = "PASSWORD_STORE_DIR=${aopassDir} pass";
    };
  };
  programs.nushell.extraConfig = let
    passWrappers = builtins.toFile "pass-wrappers.nu" ''
      export def --wrapped opass [...args] {
        PASSWORD_STORE_DIR=${opassDir} PASSWORD_STORE_GPG_OPTS="--options ${opassDir}/gpg-groups.conf --trust-model always" pass ...$args
      }
      export def --wrapped aopass [...args] {
        PASSWORD_STORE_DIR=${aopassDir} pass ...$args
      }
    '';
  in ''
    use ${passWrappers} *
  '';
}
