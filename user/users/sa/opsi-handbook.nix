{pkgs, ...}: let
  opsi-handbook = pkgs.writeShellApplication {
    name = "opsi-handbook";
    runtimeInputs = [pkgs.mdbook pkgs.mdbook-linkcheck];
    text = ''
      mdbook serve -p "''${OPSI_HANDBOOK_PORT:-8080}" "''$HOME/opsi-data/operations-handbook"
    '';
  };
in {
  systemd.user.services.opsi-handbook = {
    Unit.PartOf = ["default.target"];
    Install.WantedBy = ["default.target"];

    Service = {
      Environment = [
        "OPSI_HANDBOOK_PORT=1876"
      ];
      ExecStart = ''
        ${opsi-handbook}/bin/opsi-handbook
      '';
      Restart = "always";
    };
  };
}
