{
  pkgs,
  lib,
  config,
  ...
}: {
  options.booq.virtualisation.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };
  options.booq.virtualisation.libvirtUsers = lib.mkOption {
    default = [];
    type = lib.types.listOf lib.types.str;
  };

  config = lib.mkIf config.booq.virtualisation.enable {
    virtualisation.libvirtd.enable = true;
    environment.systemPackages = with pkgs; [virt-manager];
    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    networking.nftables.enable = false; # bug https://github.com/NixOS/nixpkgs/issues/263359

    users.users = builtins.foldl' (acc: user: acc // {"${user}".extraGroups = ["libvirtd"];}) {} config.booq.virtualisation.libvirtUsers;
  };
}
