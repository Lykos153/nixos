{
  # some more paths maybe: https://www.reddit.com/r/NixOS/comments/ymq9s2/comment/iv6cl56/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
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
  users.mutableUsers = false;
}
