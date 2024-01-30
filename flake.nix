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
          pre-commit-sops-updatekeys = pkgs.callPackage ./pkgs/pre-commit-sops-updatekeys.nix {};
          pre-commit-nix-fmt = pkgs.callPackage ./pkgs/pre-commit-nix-fmt.nix {};
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              just
              sops
              ssh-to-age
              age
              pre-commit-sops-updatekeys
              pre-commit-nix-fmt
              pam_u2f
              stylish-haskell
              git-branchless
              cachix
            ];
          };
        }) // {
    templates = {
      # TODO: Check what https://github.com/jonringer/nix-template does
      pythonenv = {
        path = ./templates/pythonenv;
        description = "Flake to setup python virtualenv with direnv";
      };
      go = {
        path = ./templates/go;
        description = "Flake to setup go environment with direnv";
      };

      direnv = direnv.templates.default;

    };
  };
}
