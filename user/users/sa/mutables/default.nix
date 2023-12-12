{config, ...}: {
  home.file."garden.yaml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/user/users/sa/mutables/garden.yaml";
}
