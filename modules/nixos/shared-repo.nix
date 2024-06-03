{
  lib,
  config,
  ...
}: let
  cfg = config.booq.shared-repo;
in {
  options.booq.shared-repo = {
    enable = lib.mkEnableOption "shared-repo";
  };
  config = lib.mkIf cfg.enable {
    environment = lib.mkIf config.booq.impermanence.enable {
      persistence."${config.booq.impermanence.persistRoot}" = {
        directories = [
          {
            directory = "/etc/nixos";
            user = "root";
            group = "wheel";
            mode = "u=rwx,g=srwx,o=";
          }
        ];
      };
    };
    # TODO: systemd service after mounting /etc/nixos to do:
    # setfacl -d -m g:wheel:rwX /etc/nixos/
  };
}
