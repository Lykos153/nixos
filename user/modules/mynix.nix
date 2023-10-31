{config, ...}: {
  home.shellAliases = {
    hmb = "mynix build user";
    hms = "mynix switch user";
    renix = "mynix switch system";
    testnix = "mynix test system";
  };
  programs.nushell = {
    shellAliases = config.home.shellAliases;
    extraConfig = ''
      def mynix [ action:string , target:string] {
        match $target {
          "system" => (sudo nixos-rebuild $action --flake $"($env.HOME)/nixos/system#(hostname)")
          "user" => (home-manager $action -b $"bak.(date now | date format "%s")" --flake $"($env.HOME)/nixos/user#(id -un)")
        }
      }
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
            mynix switch $1 &&
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
