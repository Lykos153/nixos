{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.timewarrior;
in {
  options.booq.timewarrior = {
    enable = lib.mkEnableOption "timewarrior";
  };
  config = let
    timew-report = pkgs.python3Packages.callPackage (
      {
        buildPythonPackage,
        fetchFromGitHub,
        pytest,
        python-dateutil,
        deprecation,
      }:
        buildPythonPackage rec {
          pname = "timew-report";
          version = "8523906";
          src = fetchFromGitHub {
            owner = "lauft";
            repo = pname;
            rev = version;
            sha256 = "sha256-tquiNm4MiN6as43wE8I5fhjEB/3Aaz1zjhJa206k030=";
          };

          buildInputs = [pytest];
          propagatedBuildInputs = [python-dateutil deprecation];

          meta = with lib; {
            description = "An interface for Timewarrior report data";
            homepage = "https://github.com/lauft/timew-report";
            license = licenses.mit;
          };
        }
    ) {};
    tw-hours = pkgs.stdenv.mkDerivation {
      name = "tw-hours";
      propagatedBuildInputs = [
        (pkgs.python3.withPackages (pp: [
          pp.tabulate
          timew-report
        ]))
      ];
      dontUnpack = true;
      installPhase = "install -Dm755 ${./extensions/hours} $out/bin/hours";
    };
    tw-now = pkgs.writeShellApplication {
      name = "tw-now";
      runtimeInputs = [pkgs.coreutils pkgs.timewarrior];
      text = builtins.readFile ./extensions/now;
    };
    tw-done = pkgs.writeShellApplication {
      name = "tw-done";
      runtimeInputs = [pkgs.coreutils pkgs.timewarrior];
      text = builtins.readFile ./extensions/done;
    };
  in
    lib.mkIf cfg.enable {
      programs.zsh.shellAliases.twedit = ''$EDITOR "''${TIMEWARRIORDB:="$HOME/.timewarrior"}/data/$(date +%Y-%m.data)"; rm -f ''${TIMEWARRIORDB:="$HOME/.timewarrior"}/data/tags.data; timew &>/dev/null; :'';
      home.shellAliases.tw = "toki";

      home.file.".timewarrior/extensions/hours".source = "${tw-hours}/bin/hours";
      home.file.".timewarrior/extensions/now".source = "${tw-now}/bin/tw-now";
      home.file.".timewarrior/extensions/done".source = "${tw-done}/bin/tw-done";
      home.packages = [pkgs.toki];
    };
}
