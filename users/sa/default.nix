{
  pkgs,
  config,
  ...
}: {
  booq.gui.enable = true;
  booq.gui.sway.enable = false;
  booq.gui.xmonad.enable = true;
  booq.talon.enable = false;

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
    kdePackages.konversation
    mumble
    git-crypt
    openstackclient
    openstack-rs
    sops
    age
    sshuttle
  ];
  imports = [
    ./style
    ./ssh
    ./autostart.nix
    ./calendar.nix
    ./gui
    ./glab
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
    ./nushell.nix
    ./annextimelog
  ];
}
