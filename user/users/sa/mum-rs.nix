{pkgs, ...}: let
  mum = pkgs.lykos153.mum;
  mum-msglog = pkgs.writeShellApplication {
    name = "mum-msglog";
    runtimeInputs = [mum pkgs.coreutils pkgs.gnugrep];
    text = ''
      echo "Starting"
      msglog="/run/user/$(id -u)/mum_messages.log"
      touch "$msglog" || echo "ERROR creating message log in $msglog"
      while sleep 10; do
        if mumctl status | grep "Unable to connect to mumd" > /dev/null; then
          echo "Waiting for mumd to start..."
          continue
        fi

        if mumctl status | grep "Not connected to a server" > /dev/null; then
          echo "Waiting for connection to a server..."
          continue
        fi
        mumctl messages | tee -a "$msglog"
        mumctl messages -f | tee -a "$msglog"
      done
      echo "Stopping"
    '';
  };
in {
  home.packages = with pkgs; [
    mum
    mum-rofi
    mum-msglog
  ];

  systemd.user.services.mumd = {
    Unit.PartOf = ["default.target"];
    Unit.After = ["pipewire.service"];
    Install.WantedBy = ["default.target"];

    Service = {
      ExecStart = ''
        ${mum}/bin/mumd
      '';
      Restart = "always";
    };
  };

  systemd.user.services.mum-msglog = {
    Unit.PartOf = ["default.target"];
    Unit.Requires = ["mumd.service"];
    Install.WantedBy = ["default.target"];

    Service = {
      ExecStart = ''
        ${mum-msglog}/bin/mum-msglog
      '';
      Restart = "always";
    };
  };
}
