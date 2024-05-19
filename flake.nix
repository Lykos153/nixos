{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    direnv.url = "github:nix-community/nix-direnv";
    home-manager.url = "github:nix-community/home-manager";
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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nur,
    ...
  } @ inputs: let
    userOverlays = [
      nur.overlay
      inputs.mynur.overlay
      inputs.talon-nix.overlays.default
      inputs.rofi-mum.overlays.default
      inputs.nix-vscode-extensions.overlays.default
      (
        # Add packages from flake inputs to pkgs
        final: prev: {
          toki = inputs.toki.outputs.defaultPackage.${prev.system};
          kubectl = inputs.krew2nix.outputs.packages.${prev.system}.kubectl;
          repos = {
            talon-community = inputs.talon-community;
            cursorless-talon = inputs.cursorless-talon;
          };
        }
      )
    ];
    homeManagerModules.booq = import ./modules/homeManager;
    userModules = [
      homeManagerModules.booq
      inputs.sops-nix.homeManagerModule
      inputs.stylix.homeManagerModules.stylix
      ./user/home.nix
    ];
  in
    rec {
      lib = import ./lib;
      nixosModules.booq = import ./modules/nixos;
      nixosConfigurations = lib.nixos.mkHosts {
        inherit (inputs) nixpkgs;
        modules = [
          nixosModules.booq
          inputs.disko.nixosModules.disko
          inputs.impermanence.nixosModules.impermanence
          inputs.sops-nix.nixosModules.sops
          ./system/configuration.nix
        ];
        machinedir = ./system/machines;
      };
      inherit homeManagerModules;
      homeConfigurations = lib.homeManager.mkConfigs {
        inherit nixosConfigurations;
        inherit (inputs) nixpkgs home-manager;
        overlays = userOverlays;
        modules = userModules;
        userdir = ./user/users;
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
    }
    // inputs.flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      pre-commit-sops-updatekeys = pkgs.callPackage ./pkgs/pre-commit-sops-updatekeys {};
    in {
      packages = {inherit pre-commit-sops-updatekeys;};
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
    });
}
