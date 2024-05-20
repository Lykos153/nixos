{config, ...}: {
  home.file."garden.yaml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/user/users/${config.home.username}/mutables/garden.yaml";
}
