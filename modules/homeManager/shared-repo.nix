{
  lib,
  config,
  ...
}: let
  cfg = config.booq.shared-repo;
in {
  # TODO: how to share options between nixos and home manager config?
  options.booq.shared-repo = {
    enable = lib.mkEnableOption "shared-repo";
  };
  config = lib.mkIf cfg.enable {
    programs.git.extraConfig.safe.directory = ["/etc/nixos" "/etc/nixos/.git"];
  };
}
