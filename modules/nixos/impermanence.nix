{
  lib,
  config,
  ...
}: let
  cfg = config.booq.impermanence;
in {
  options.booq.impermanence.enable = lib.mkEnableOption "impermanence";
  options.booq.impermanence.persistRoot = lib.mkOption {
    default = "/persist";
    type = lib.types.str;
  };
  config = lib.mkIf cfg.enable {
    # some more paths maybe: https://www.reddit.com/r/NixOS/comments/ymq9s2/comment/iv6cl56/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    environment.persistence."${config.booq.impermanence.persistRoot}" = {
      hideMounts = true;
      directories =
        [
          "/var/log"
          "/var/tmp"
          "/var/lib/nixos"
          "/var/lib/systemd"
          {
            directory = "/root";
            user = "root";
            group = "root";
            mode = "u=rwx,g=rx,o=";
          }
        ]
        ++ lib.optional config.hardware.bluetooth.enable "/var/lib/bluetooth"
        ++ lib.optional config.networking.networkmanager.enable "/etc/NetworkManager/system-connections"
        ++ lib.optional config.virtualisation.libvirtd.enable "/var/lib/libvirt"
        ++ lib.optional config.virtualisation.docker.enable "/var/lib/docker";
      files =
        [
          "/etc/machine-id"
        ]
        ++ lib.optionals config.services.openssh.enable [
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
        ];
    };
    users.mutableUsers = false;

    # Workaround for 'Directory "/var/lib/private" already exists, but has mode 0755 that is too permissive (0700 was requested), refusing.'
    # see https://github.com/nix-community/impermanence/issues/254
    system.activationScripts."createPersistentStorageDirs".deps = ["var-lib-private-permissions" "users" "groups"];
    system.activationScripts = {
      "var-lib-private-permissions" = {
        deps = ["specialfs"];
        text = ''
          mkdir -p ${config.booq.impermanence.persistRoot}/var/lib/private
          chmod 0700 ${config.booq.impermanence.persistRoot}/var/lib/private
        '';
      };
    };
  };
}
