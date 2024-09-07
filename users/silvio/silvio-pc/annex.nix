{
  pkgs,
  config,
  ...
}: {
  sops.secrets.annex-autostart.sopsFile = ./secrets.yaml;
  xdg.configFile."git-annex/autostart".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/sops-nix/secrets/annex-autostart";

  systemd.user.services.git-annex-assistant = {
    Unit.PartOf = ["hm-graphical-session.target"];
    Install.WantedBy = ["hm-graphical-session.target"];

    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.git-annex}/bin/git-annex assistant --autostart
      '';
    };
  };
}
