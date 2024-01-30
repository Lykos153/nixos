{pkgs, ...}: {
  xdg.configFile."aacs/KEYDB.cfg".source =
    (pkgs.fetchzip {
      url = "https://web.archive.org/web/20240117220743if_/http://fvonline-db.bplaced.net/export/keydb_deu.zip";
      hash = "sha256-NAteZ+5gmK4+etMb7fZawB8JZn9J3rvGMm2WcwRT6Zw=";
    })
    + "/keydb.cfg";

  home.packages = [
    pkgs.handbrake
  ];
}
