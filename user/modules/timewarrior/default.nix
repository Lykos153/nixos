{ pkgs, lib, ... }:
let
  timew-report = pkgs.python3Packages.callPackage (
    { buildPythonPackage
    , fetchFromGitHub
    , pytest
    , python-dateutil
    , deprecation
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


      buildInputs = [ pytest ];
      propagatedBuildInputs = [ python-dateutil deprecation ];

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
    runtimeInputs = [ pkgs.coreutils pkgs.timewarrior ];
    text = builtins.readFile ./extensions/now;
  };
  tw-done = pkgs.writeShellApplication {
    name = "tw-done";
    runtimeInputs = [ pkgs.coreutils pkgs.timewarrior ];
    text = builtins.readFile ./extensions/done;
  };
  tw-note = pkgs.writeShellApplication {
    name = "tw-note";
    runtimeInputs = [ pkgs.timewarrior pkgs.gnused pkgs.jq ];
    text = builtins.readFile ./utils/tw-note;
  };
in
{
  #TODO: if zsh is used
  programs.zsh = {
    shellAliases = {
      # Just a bit shorter to type
      tw = "timew";

      # Start of business. Adds a zero-length interval with start=end=now. This is the first command I type when I start working. Useful in conjunction with `twnow` and `twdone`. Alternative (and maybe a bit more cheerful) names: hi, moin, howdy, gmornin, you name it...
      sob = "timew track $(date +%FT%T -d@$(expr $(date +%s) - 1)) - $(date +%FT%T) sob";

      # End of business. Adds a zero-length interval to denote the end of your working day. Useful because (1) it stops the currently active tracking and (2) if you don't have an active tracking, it helps you to reverse-engineer your day afterwards. Alternative names: cya, gnight
      eob = "timew stop >/dev/null; sleep 1; timew track $(date +%FT%T -d@$(expr $(date +%s) - 1)) - $(date +%FT%T) eob";

      twcont = "timew start >/dev/null && timew join @1 @2 && timew; :";

      afk = "timew stop && timew continue >/dev/null && timew tag afk >/dev/null; timew; :";
      re = "timew stop && timew continue >/dev/null && timew untag afk >/dev/null; timew; :";
      pause = "timew start pause";
      twids = "timew summary :ids";

      # Open the current month in $EDITOR and clear the tag database. (If you edit tags, the tag database may become inconsistent. It will be re-generated on the next invocation of timew.)
      twedit = ''$EDITOR "''${TIMEWARRIORDB:="$HOME/.timewarrior"}/data/$(date +%Y-%m.data)"; rm -f ''${TIMEWARRIORDB:="$HOME/.timewarrior"}/data/tags.data; timew &>/dev/null; :'';
    };
  };
  home.file.".timewarrior/extensions/hours".source = "${tw-hours}/bin/hours";
  home.file.".timewarrior/extensions/now".source = "${tw-now}/bin/tw-now";
  home.file.".timewarrior/extensions/done".source = "${tw-done}/bin/tw-done";
  home.packages = [ tw-note ];
}
