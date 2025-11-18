{
  stdenv,
  lib,
}:
stdenv.mkDerivation {
  name = "cb";
  src = ./cb;

  preferLocalBuild = true;

  unpackPhase = "true";

  installPhase = ''
    install -Dm755 $src $out/bin/cb
  '';

  meta = with lib; {
    description = "unify the copy and paste commands into one intelligent chainable command";
    homepage = "https://github.com/javier-lopez/learn/blob/master/sh/tools/cb";
    platforms = platforms.all;
  };
}
