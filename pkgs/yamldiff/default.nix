{
  stdenv,
  lib,
  python3,
}:
stdenv.mkDerivation {
  name = "yamldiff";
  src = ./yamldiff;

  preferLocalBuild = true;

  unpackPhase = "true";

  buildInputs = [
    (python3.withPackages (ps:
      with ps; [
        ps.pyyaml
        ps.click
      ]))
  ];

  installPhase = ''
    install -Dm755 $src $out/bin/yamldiff
  '';
}
