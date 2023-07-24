{pkgs, ...}: let
  wallpapers = [
    # from https://pixabay.com/users/bessi-909086/
    (pkgs.fetchurl {
      url = "https://pixabay.com/get/g08cdfba780eebc318526e6dd785a051d99a8cd3885658493e7582feb18830b2ca4f5a25dcbcfe4f1430916550857053b28e90cc956d50f413e452006516672fae218007b7cb3e266ee97eb47febd7764_1920.jpg?attachment=";
      hash = "sha256-PL1fH/v3S6c6BhV6tnNNFiCYLZVM+0SayCxesqYgYgY=";
    })
    (pkgs.fetchurl {
      url = "https://pixabay.com/get/g4312c9033f5220b563030089bc71b9a16d6e97afff5354874017d5a3255124ff2b2e078ad541367365e177c857e8196e623b53c8fd7071444d8e44c90de8bbaf8045b7bf3faf91730a295cbc288f39ae_1920.png?attachment=";
      hash = "sha256-0qu5abUwA+6lAxR3ah6SaKJilCLGs0tyt7F7OoguOf4=";
    })
    (pkgs.fetchurl {
      url = "https://pixabay.com/get/g978fcfeb1850639634ebb0b4c1765dfc43faace40e2a6c337841beac77b8f1e4c017abf6d9c2137eda621723224040daf05c63aff7496e232b0b7f942c0e011a11319d5be5438d6a9b3485ca6b27609c_1920.jpg?attachment=";
      hash = "sha256-3vmSqmeHRT4n6kVKczriU564hJwkwaq+9d50pLoFklU=";
    })
    (pkgs.fetchurl {
      url = "https://pixabay.com/get/g3439a5f429d282cfd6646076369f4717d4d389ec436b39baf76d9e88b55d1efc34e57ab57b45c610c31751ecc48eba9260ebf5bef6daa5dacbd2bee6ed11af0dbdd00a52a7a6173726c4fb7e75570f6c_1920.jpg?attachment=";
      hash = "sha256-6tgjJlm8qdPNfECHTDOkioDABwMGom7YAcyRvqke2cQ=";
    })
    (pkgs.fetchurl {
      url = "https://pixabay.com/get/gad83d7242ae8fbb660b71a6157aeedf687b2a007cd2b38f775087452e3b4db0e17f100157e53b20020644c3a514e2d75edd6a498dcfd06fda58d020f305a0b5d8b43071039dbb463ca839c76292fb5c9_1920.jpg?attachment=";
      hash = "sha256-kGO2jTJbpif98+kqzuE8o2mKEh5AM9nEBQVjgKUvUa8=";
    })
    (pkgs.fetchurl {
      url = "https://pixabay.com/get/g8306c64a5a809e644b08ae9cd46e9d133fa527d0aaf1c4ea7fb65253a89b26ff92948d103d33e6748a762900f175340136435d73fba1583b6eebf7d90ce979d14655861d2e0f72bee914b220b5715df0_1920.jpg?attachment=";
      hash = "sha256-mGpdZoblnk/a91On7VQSiseJghnbHT3yQsDvyjHlUo8=";
    })
  ];
  wallpaper = builtins.elemAt wallpapers 3;
in {
  stylix.polarity = "dark";
  stylix.image = wallpaper;
  home.file.".background-image".source = wallpaper;
}
