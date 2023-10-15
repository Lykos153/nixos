{pkgs, ...}:
let
  numen-config = pkgs.stdenv.mkDerivation {
    name = "numen-config";
    propagatedBuildInputs = [ pkgs.rofi ];
    dontUnpack = true;
    buildPhase = "true";
    installPhase = ''
      phrasedir=$out/phrases
      scriptdir=$out/scripts
      install -d $phrasedir $scriptdir
      cp -r ${./phrases}/* $phrasedir
      for f in ${./scripts}/*; do
        install -m 770 $f $scriptdir
      done

      for dir in $phrasedir/* $scriptdir; do
        substituteInPlace $dir/* \
          --replace @PHRASEDIR@ $phrasedir \
          --replace @SCRIPTDIR@ $scriptdir \
          --replace "numenc" " ${pkgs.numen}/bin/numenc" \
          --replace " rofi" " ${pkgs.rofi}/bin/rofi" \
          --replace " cat" " ${pkgs.coreutils}/bin/cat" \
          --replace " sed" " ${pkgs.gnused}/bin/sed" \

      done

      for f in "${pkgs.numen}/etc/numen/scripts"; do
        ln -s "$f" $scriptdir
      done
    '';
  };

in {
  services.numen = {
    enable = true;
    dotoolXkbLayout = "de";
    extraArgs = "--verbose --phraselog=%h/.numen-phraselog";
    phrases = [
      "${numen-config}/phrases/sleep/sleep.phrases"
      "${numen-config}/phrases/always/help.phrases"
    ];
  };
}
