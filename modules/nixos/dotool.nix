{
  lib,
  config,
  ...
}: let
  cfg = config.booq.dotool;
in {
  options.booq.dotool = {
    enable = lib.mkEnableOption "dotool";
    users = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.str;
    };
  };
  config = let
    mkUserConfig = user: {
      ${user}.extraGroups = [
        "input"
      ];
    };
  in
    lib.mkIf cfg.enable {
      services.udev.extraRules = ''
        KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
      '';
      users.users = (
        lib.mkMerge (
          builtins.foldl' (acc: user: acc ++ [(mkUserConfig user)]) [] cfg.users
        )
      );
    };
}
