{
  stdenv,
  lib,
  makeWrapper,
  nushell,
  sops,
  fd,
}:
stdenv.mkDerivation rec {
  name = "pre-commit-sops-updatekeys";
  buildInputs = [makeWrapper];
  nativeBuildInputs = [sops fd nushell];
  src = ./.;
  buildPhase = "true";
  installPhase = ''
    install -m 755 -D $src/pre-commit-sops-updatekeys.nu $out/bin/pre-commit-sops-updatekeys
    wrapProgram $out/bin/pre-commit-sops-updatekeys \
      --prefix PATH : ${lib.makeBinPath nativeBuildInputs}
  '';
}
