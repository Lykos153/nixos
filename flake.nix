{
  inputs = {
    direnv.url = "github:nix-community/nix-direnv";

    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs";
    nix-pre-commit.url = "github:jmgilman/nix-pre-commit";
  };

  outputs = { self, nixpkgs, flake-utils, nix-pre-commit, direnv }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        config = {
          repos = [
            {
              repo = "https://github.com/pre-commit/pre-commit-hooks";
              rev = "v4.4.0";
              hooks = [
                { id = "trailing-whitespace"; }
                { id = "end-of-file-fixer"; }
                { id = "mixed-line-ending"; }
              ];
            }
            {
              repo = "local";
              hooks = [
                {
                  id = "stylish-haskell";
                  name = "stylish-haskell";
                  description = "Haskell code prettifier.";
                  entry = "${pkgs.stylish-haskell}/bin/stylish-haskell -i";
                  language = "system";
                  files = "\\.l?hs$";
                }
              ];
            }
          ];
        };
      in
      {
        devShell = pkgs.mkShell {
          shellHook = (nix-pre-commit.lib.${system}.mkConfig {
            inherit pkgs config;
          }).shellHook;
        };

        templates = {
          # TODO: Check what https://github.com/jonringer/nix-template does
          pythonenv = {
            path = ./templates/pythonenv;
            description = "Flake to setup python virtualenv with direnv";
          };

          direnv = direnv.defaultTemplate;

        };
      });
}
