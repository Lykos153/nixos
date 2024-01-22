{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "talon"
    ];

  home.packages = [
    pkgs.talon
  ];

  systemd.user.services.talon = {
    Unit = {
      PartOf = ["graphical-session.target"];
    };

    Install.WantedBy = ["graphical-session.target"];

    Service = {
      ExecStart = ''
        ${pkgs.talon}/bin/talon
      '';
      Restart = "on-failure";
    };
  };

  home.file.".talon/user/cursorless-talon".source = pkgs.repos.cursorless-talon;
  home.file.".talon/user/cursorless-settings".source = ./cursorless-settings;
  home.file.".talon/user/talon-community".source = pkgs.stdenv.mkDerivation {
    name = "talon-community";
    src = ./.;
    buildPhase = "true";
    installPhase = ''
      mkdir $out
      for f in ${pkgs.repos.talon-community}/*; do
        ln -s $f $out/$(basename $f)
      done
      cp -r ./talon-settings $out/settings
    '';
  };
}
