
{writeShellApplication }: writeShellApplication {
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
          }
