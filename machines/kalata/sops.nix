{config, lib, ...}: {
  sops.age.sshKeyPaths = lib.mkForce [];
  # needs to be the actual path, because sops is loaded before impermanence
  sops.age.keyFile = "${config.booq.impermanence.persistRoot}/var/lib/sops-nix/age.key";
  sops.gnupg.sshKeyPaths = lib.mkForce [];
}
