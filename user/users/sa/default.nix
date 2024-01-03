{
  pkgs,
  config,
  ...
}: {
  booq.gui.enable = true;
  booq.gui.sway.enable = false;
  booq.gui.xmonad.enable = true;

  programs.git = let
    m = config.accounts.email.accounts.cah;
  in {
    userEmail = m.address;
    userName = m.realName;
    signing = {
      key = m.gpg.key;
      signByDefault = true;
    };
  };
  programs.ssh.extraConfig = ''
    User silvioankermann
  '';
  home.packages = with pkgs; [
    rocketchat-desktop
    konversation
    mumble
    git-crypt
    openstackclient
    sops
    age
    sshuttle
  ];
  imports = [
    ./style
    ./autostart.nix
    ./calendar.nix
    ./gui
    ./zoom.nix
    ./pass.nix
    ./mum-rs
    ./sops.nix
    ./yk8s
    ./opsi-handbook.nix
    ./opsi-prepare.nix
    ./mail.nix
    ./tmate.nix
    ./bugwarrior.nix
    ./mutables
  ];
}
