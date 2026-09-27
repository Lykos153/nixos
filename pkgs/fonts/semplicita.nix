{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  pname = "semplicita";
  version = "2500";

  src = fetchzip {
    url = "https://www.1001fonts.com/download/semplicita.zip";
    hash = "sha256-l69p5nYjDzbMramYu3dxeCT78qdXI3EScGqFxcpSCwE=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype Semplicita/*.otf

    runHook postInstall
  '';

  meta = {
    # license = lib.licenses.cc-by-nd-30;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [lykos153];
  };
}
