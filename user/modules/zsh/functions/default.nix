{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./nix.nix
    ./annex.nix
  ];
  programs.zsh = {
    initExtra = ''
        rbtohex() {
          # Convert a raw binary string to a hexadecimal string
          ( od -An -vtx1 | tr -d ' \n' )
        }

        hextorb() {
          # Convert a hexadecimal string to a raw binary string
          ( tr '[:lower:]' '[:upper:]' | sed -e 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI'| xargs printf )
        }

        #TODO: Maybe implement this as a target
        dnd () {
          com_services="element-desktop.service gajim.service thunderbird.service"
          case $1 in
            off)
              printf $com_services | xargs -d' ' systemctl --user start
              ;;
            *)
              printf $com_services | xargs -d' ' systemctl --user stop
              ;;
          esac
        }

        remote-debug() {
          tmux new-session -s remote-debug -d
          tmux send-keys -t remote-debug 'nix run "nixpkgs#upterm" -- host --server ssh://nbg.booq.org:2222 --force-command "tmux attach -t remote-debug"' Enter
          tmux send-keys -t remote-debug 'q' Enter
          tmux send-keys -t remote-debug Enter
          tmux attach -t remote-debug
        }

        cdt () {
          template=$1
          suffix=".XXXXX"
          mkdir -p /tmp/"$(dirname "$template")"
          cd $(mktemp -d --tmpdir=/tmp "''${template:="cdt"}$suffix")
        }

        tclone () {
          repo=$1

          # Derive directory from the repository name
          # Try using "humanish" part of source repo if user didn't specify one
          if test -f "$repo"
          then
              # Cloning from a bundle
              dir=$(echo "$repo" | sed -e 's|/*\.bundle$||' -e 's|.*/||g')
          else
              dir=$(echo "$repo" |
                  sed -e 's|/$||' -e 's|:*/*\.git$||' -e 's|.*[/:]||g')
          fi

          cdt tclone-$dir
          pwd

          git clone "$repo" .
        }

        rg2code() { rg $@ -l | xargs codium; }

      pass_pop() {
        local codepath="$1"
        pass show "$codepath" | head -n1 | cb
        pass show "$codepath" | tail -n+2 | pass insert -fm "$codepath" > /dev/null
        echo "$(pass show "$codepath" | wc -l) entries left"
      }
    '';
  };
}
