{writeShellApplication, sops }:

writeShellApplication {
            name = "pre-commit-sops-updatekeys";
            runtimeInputs = [ sops ];
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
          }
