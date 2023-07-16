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
          pre-commit-sops-updatekeys = pkgs.writeShellApplication {
            name = "pre-commit-sops-updatekeys";
            runtimeInputs = [ pkgs.sops ];
            text = ''
              fail=false
              while [[ $# -gt 0 ]]; do
              if [ "$(basename "$1")" = ".sops.yaml" ]; then
                result="$(find "$(dirname "$1")" -type f -name '*secrets.yaml' -exec sops updatekeys --yes {} \; 2>&1)"
              else
                result="$(sops updatekeys --yes "$1" 2>&1)"
              fi
              if [ -n "$(echo "$result" | (grep -vP '(Syncing keys for file|already up to date)' || true))" ]; then
                echo "$result"
                fail=true
              fi
              shift
              done
              test "$fail" = false
            '';
          };
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              sops
              ssh-to-age
              age
              pre-commit-sops-updatekeys
              pam_u2f
              stylish-haskell
            ];
          };
        }) // {
    templates = {
      # TODO: Check what https://github.com/jonringer/nix-template does
      pythonenv = {
        path = ./templates/pythonenv;
        description = "Flake to setup python virtualenv with direnv";
      };

      direnv = direnv.templates.default;

    };
  };
}
