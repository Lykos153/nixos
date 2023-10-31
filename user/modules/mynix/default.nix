{config, ...}: {
  home.shellAliases = {
    hmb = "mynix user build";
    hms = "mynix user switch";
    renix = "mynix system switch";
    testnix = "mynix system test";
  };
  programs.nushell = {
    shellAliases = config.home.shellAliases;
    extraConfig = ''
      use ${./mynix-mod.nu} *
    '';
  };
  programs.zsh = {
    initExtra = ''
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

      mynix() {
        case $1 in
          system)
            noglob sudo nixos-rebuild $2 --flake "$HOME/nixos/system#$(hostname)"
            ;;
          user)
            noglob home-manager $2 -b "bak.$(date '+%s')" --flake "$HOME/nixos/user#$(id -un)"
            ;;
          *)
            echo "Usage: $0 system|user build|switch"
            return 1
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
            mynix $1 switch &&
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

    '';
  };
}
