{
  # needs to be the actual path, because sops is loaded before impermanence
  sops.age.sshKeyPaths = [];
  sops.age.keyFile = "/var/lib/sops-nix/age.key";
  sops.age.generateKey = true;
  sops.gnupg.sshKeyPaths = [];
}
