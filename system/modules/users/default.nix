{
  pkgs,
  config,
  ...
}: {
  imports = [./sops.nix];

  users.users.silvio = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.nushell;
  };

  users.users.sa = {
    uid = 1003;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.nushell;
  };

  users.users.mine = {
    uid = 1001;
    isNormalUser = true;
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  users.users.leila = {
    uid = 1002;
    isNormalUser = true;
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  users.users.root.shell = pkgs.zsh;
}
