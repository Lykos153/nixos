{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.mynix;
in {
  options.booq.mynix = {
    enable = lib.mkEnableOption "mynix";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      home-manager
    ];
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
              noglob sudo nixos-rebuild $2 --flake "$HOME/nixos#$(hostname)"
              ;;
            user)
              noglob home-manager $2 -b "bak.$(date '+%s')" --flake "$HOME/nixos#$(id -un)"
              ;;
            upgrade)
              flake="$HOME/nixos"
              git -C $flake status --short . | grep -v flake.lock && echo "$flake is dirty" && return 1
              nix flake update "$flake" &&
              if git -C "$flake" diff --quiet flake.lock; then
                echo "Nothing to do!"
                return 0
              fi
              mynix system build &&
              mynix user build &&
              git -C "$flake" commit -m "Upgrade $(basename "$flake")" flake.lock
              ;;
            *)
              echo "Usage: $0 system|user|upgrade build|switch"
              return 1
              ;;
          esac
        }


        nixtemplate () {
          noglob nix flake new -t github:Lykos153/nixos#$1 .
        }

      '';
    };
  };
}
