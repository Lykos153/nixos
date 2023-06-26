{
  description = "A collection of flake templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    direnv.url = "github:nix-community/nix-direnv";
  };

  outputs = { self
    , nixpkgs
    , flake-utils
    , direnv
  }:

    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              sops
            ];
          };
        }) // {
    templates = {
      # TODO: Check what https://github.com/jonringer/nix-template does
      pythonenv = {
        path = ./templates/pythonenv;
        description = "Flake to setup python virtualenv with direnv";
      };

      direnv = direnv.defaultTemplate;

    };
  };
}
