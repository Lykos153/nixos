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
      opass = "PASSWORD_STORE_DIR=${opassDir} pass";
      aopass = "PASSWORD_STORE_DIR=${aopassDir} pass";
    };
  };
  programs.nushell.extraConfig = let
    passWrappers = builtins.writeFile "pass-wrappers.nu" ''
      export def --wrapped opass [...args] {
        PASSWORD_STORE_DIR=${opassDir} pass ...$args
      }
      export def --wrapped aopass [...args] {
        PASSWORD_STORE_DIR=${aopassDir} pass ...$args
      }
    '';
  in ''
    use ${passWrappers} *
  '';
}
