{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      # "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      # { file = "/etc/shadow"; parentDirectory = { group = "shadow"; mode = "u=rw,g=r,o="; }; }
    ];
  };
  users.users.silvio.passwordFile = "/persist/passwords/silvio";
  users.users.root.passwordFile = "/persist/passwords/root";
  users.mutableUsers = false;
}
