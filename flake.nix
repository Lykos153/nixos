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
                # TODO: get regex from .sops.yaml, otherwise they drift apart
                result="$(find "$(dirname "$1")" -type f -path '*secrets*' -exec sops updatekeys --yes {} \; 2>&1)"
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
          pre-commit-nix-fmt = pkgs.writeShellApplication {
            name = "pre-commit-nix-fmt";
            runtimeInputs = [];
            text = ''
              user=false
              system=false
              while [[ $# -gt 0 ]]; do
                dir="$(echo "$1" | cut -d'/' -f1)"
                case "$dir" in
                  "user")
                    if [ "$user" != "true" ]; then
                      pushd user
                      nix fmt
                      popd
                      user=true
                    fi
                    ;;
                  "system")
                    if [ "$system" != "true" ]; then
                      pushd system
                      nix fmt
                      popd
                      system=true
                    fi
                    ;;
                esac
                shift
              done
            '';
          };
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
