{
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    direnv.url = "github:nix-community/nix-direnv";
    # home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    # home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mynur.url = "github:Lykos153/nur-packages";
    rofi-mum.url = "github:lykos153/rofi-mum";
    toki.url = "github:lykos153/toki";
    krew2nix.url = "github:lykos153/krew2nix";
    krew2nix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    talon-nix.url = "github:nix-community/talon-nix";
    talon-nix.inputs.nixpkgs.follows = "nixpkgs";
    talon-community.url = "github:Lykos153/talon-community";
    talon-community.flake = false;
    cursorless-talon.url = "github:cursorless-dev/cursorless-talon";
    cursorless-talon.flake = false;
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    lix-module = {
      # url = "git+https://git.lix.systems/lix-project/nixos-module";
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0-rc1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nur,
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        lib = import ./lib;
        overlays = {
          nur = inputs.nur.overlay;
          mynur = inputs.mynur.overlay;
          talon-nix = inputs.talon-nix.overlays.default;
          rofi-mum = inputs.rofi-mum.overlays.default;
          nix-vscode-extensions = inputs.nix-vscode-extensions.overlays.default;
          other = (
            # Add packages from flake inputs to pkgs
            final: prev: {
              toki = inputs.toki.outputs.defaultPackage.${prev.system};
              kubectl = inputs.krew2nix.outputs.packages.${prev.system}.kubectl;
              repos = {
                talon-community = inputs.talon-community;
                cursorless-talon = inputs.cursorless-talon;
              };
            }
          );
        };
        nixosModules = {
          booq = import ./modules/nixos;
          inherit (inputs.disko.nixosModules) disko;
          inherit (inputs.impermanence.nixosModules) impermanence;
          inherit (inputs.sops-nix.nixosModules) sops;
          inherit (inputs.home-manager.nixosModules) home-manager;
          lix-module = inputs.lix-module.nixosModules.default;
        };
        nixosConfigurations = self.lib.nixos.mkHosts {
          inherit (inputs) nixpkgs;
          nixosModules = builtins.attrValues self.nixosModules;
          machinedir = ./machines;
          userdir = ./users;
          homeManagerModules = builtins.attrValues self.homeManagerModules;
        };
        homeManagerModules = {
          booq = import ./modules/homeManager;
          sops-nix = inputs.sops-nix.homeManagerModule;
          inherit (inputs.stylix.homeManagerModules) stylix;
          overlays = {
            nixpkgs.overlays = builtins.attrValues self.overlays;
          };
        };
        homeConfigurations = self.lib.homeManager.mkConfigs {
          inherit (self) nixosConfigurations;
          inherit (inputs) nixpkgs home-manager;
          modules = builtins.attrValues self.homeManagerModules;
          userdir = ./users;
        };
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

          direnv = inputs.direnv.templates.default;
        };
      };
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: let
        pre-commit-sops-updatekeys = pkgs.callPackage ./pkgs/pre-commit-sops-updatekeys {};
      in {
        packages = {
          inherit pre-commit-sops-updatekeys;
          install-image = inputs.nixos-generators.nixosGenerate {
            inherit system;
            specialArgs = {
              inherit pkgs;
            };
            modules =
              builtins.attrValues self.nixosModules
              ++ [
                ({...}: {nix.registry.nixpkgs.flake = inputs.nixpkgs;})
                {
                  # TODO: make this an actual module
                  services.openssh.enable = true;
                  booq.users.enable = true;
                  security.sudo.wheelNeedsPassword = false;
                }
              ];
            format = "install-iso";
          };
        };
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            just
            sops
            ssh-to-age
            age
            pre-commit-sops-updatekeys
            pam_u2f
            stylish-haskell
            git-branchless
            cachix
            inputs.disko.packages.${system}.disko
            haskell-language-server
            ghc
          ];
        };
      };
    };
}
