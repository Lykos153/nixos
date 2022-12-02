{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ip  = "ip --color=auto";
      ls = "lsd";
      l   = "lsd -l";
      lh  = "lsd -lh";
      la  = "lsd -la";
      tree = "lsd --tree";

      n      = "$TERM&!";

      os  = "openstack";
      k   = "kubectl";

      cal = "cal -3 --week --iso";
      dirs    = "dirs -v";
      rsynca  = "rsync -avPhL --append";
      dd      = "dd status=progress";

      g   = "git";
      ga  = "git annex";

      hmb = "_hm_nix_build_switch build user";
      hms = "_hm_nix_build_switch switch user";
      renix = "_hm_nix_build_switch switch system";
      nix = "noglob nix";
      findnix = "nix search nixpkgs";
      nownix = "nsh";

      helpme = "remote-debug";

      manix = "nix run 'github:mlvzk/manix' --"; # too big to be installed by default. Rather only pull it when needed
    };

    initExtra = ''
      bindkey '^ ' autosuggest-accept
      AGKOZAK_CMD_EXEC_TIME=5
      AGKOZAK_COLORS_CMD_EXEC_TIME='yellow'
      AGKOZAK_COLORS_PROMPT_CHAR='magenta'
      AGKOZAK_CUSTOM_SYMBOLS=( '⇣⇡' '⇣' '⇡' '+' 'x' '!' '>' '?' )
      AGKOZAK_MULTILINE=0
      AGKOZAK_PROMPT_CHAR=( ❯ ❯ ❮ )
      autopair-init

      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^X^E" edit-command-line

      unalias lsd # where does that come from anyway?

      alias -s pdf="setsid xdg-open"

      nsh () {
        local nsopts
        local cmd
        local NIXPKGS_ALLOW_UNFREE
        if [ "$1" = "--unfree" ]; then
          nsopts="--impure"
          export NIXPKGS_ALLOW_UNFREE=1
          shift
        fi
        cmd="nix shell $nsopts"
        for arg in $@; do
          if [ "''${arg#*\#}" = "$arg" ]; then
            arg="nixpkgs#$arg"
          fi
          cmd="$cmd $arg"
        done
        setopt shwordsplit
        $cmd
        unsetopt shwordsplit
      }

      nr () {
        local nropts
        local cmd
        local NIXPKGS_ALLOW_UNFREE
        if [ "$1" = "--unfree" ]; then
          nropts="--impure"
          export NIXPKGS_ALLOW_UNFREE=1
          shift
        fi
        cmd=$1
        shift
        nix run $nropts "nixpkgs#$cmd" -- $@
      }

      _hm_nix_build_switch() {
        case $2 in
          system)
            noglob sudo nixos-rebuild $1 --flake "$HOME/nixos/system#$(hostname)"
            ;;
          user)
            noglob home-manager $1 -b "bak.$(date '+%s')" --flake "$HOME/nixos/user#$(id -un)"
            ;;
          *)
            echo "Usage: $0 build|switch system|user"
            return 1
            ;;
        esac
      }

      donix () {
        case $1 in
          system | user )
            _hm_nix_build_switch switch $1
            ;;

          *)
            donix user
            ;;
        esac
      }

      upgrade () {
        case $1 in
          _check)
            flake=$2
            git -C $flake status --short . | grep -v flake.lock && echo "$flake is dirty" && return 1
            return 0
            ;;

          system | user)
            flake="$HOME/nixos/$1"
            upgrade _check "$flake" || return 1
            nix flake update "$flake" &&
            if git -C "$flake" diff --quiet flake.lock; then
              echo "Nothing to do!"
              return 0
            fi
            _hm_nix_build_switch switch $1 &&
            git -C "$flake" commit -m "Upgrade $(basename "$flake")" flake.lock
            ;;

          all)
            upgrade system &&
            upgrade user
            ;;

          *)
            echo "$0 system"
            echo "$0 user"
            echo "$0 all"
            ;;
        esac
      }

      nixtemplate () {
        noglob nix flake new -t github:Lykos153/nixos#$1 .
      }

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

        cdt $dir
        pwd

        git clone "$repo" .
      }

      rg2code() { rg $@ -l | xargs codium; }

      gesehen () {
        CDIR=$(pwd)
        DIR=$(dirname $1)
        FILE=$(basename $1)
        shift
        cd $DIR
        git annex metadata --tag gesehen -s gesehen+=`date '+%F@%H-%M'` $FILE $@
        cd $CDIR
      }

      film () {
        #ambi on
        vlc "$@"
        echo "Gesehen? "
        read yn
        case $yn in
          [YyJj]* ) gesehen "$@";;
        esac
        #ambi off
      }
    '';

    envExtra = ''
      path=("$HOME/.local/bin" $path)
      #export PYTHON_KEYRING_BACKEND=keyring_pass.PasswordStoreBackend
    '';

    profileExtra = ''
      stty -ixon # disable ctrl-s, ctrl-q
    '';

    plugins = with pkgs; [
      {
        name = "agkozak-zsh-prompt";
        src = fetchFromGitHub {
          owner = "agkozak";
          repo = "agkozak-zsh-prompt";
          rev = "v3.7.0";
          sha256 = "1iz4l8777i52gfynzpf6yybrmics8g4i3f1xs3rqsr40bb89igrs";
        };
        file = "agkozak-zsh-prompt.plugin.zsh";
      }
      {
        name = "formarks";
        src = fetchFromGitHub {
          owner = "wfxr";
          repo = "formarks";
          rev = "8abce138218a8e6acd3c8ad2dd52550198625944";
          sha256 = "1wr4ypv2b6a2w9qsia29mb36xf98zjzhp3bq4ix6r3cmra3xij90";
        };
        file = "formarks.plugin.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.6.0";
          sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
        };
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-abbrev-alias";
        src = fetchFromGitHub {
          owner = "momo-lab";
          repo = "zsh-abbrev-alias";
          rev = "637f0b2dda6d392bf710190ee472a48a20766c07";
          sha256 = "16saanmwpp634yc8jfdxig0ivm1gvcgpif937gbdxf0csc6vh47k";
        };
        file = "abbrev-alias.plugin.zsh";
      }
      {
        name = "zsh-autopair";
        src = fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
          sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
        };
        file = "autopair.zsh";
      }
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

}
