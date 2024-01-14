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
    mum-rofi.url = "github:lykos153/mum-rofi";
    toki.url = "github:lykos153/toki";
    krew2nix.url = "github:lykos153/krew2nix";
    krew2nix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    talon-nix.url = "github:nix-community/talon-nix";
    talon-nix.inputs.nixpkgs.follows = "nixpkgs";
    talon-community.url = "github:talonhub/community";
    talon-community.flake = false;
    cursorless-talon.url = "github:cursorless-dev/cursorless-talon";
    cursorless-talon.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nur,
    ...
  } @ inputs:
    rec {
      nixosConfigurations = let
        lib = (import ./system/lib.nix) {inherit nixpkgs;};
      in
        lib.mkHosts {
          modules = [
            inputs.disko.nixosModules.disko
            inputs.impermanence.nixosModules.impermanence
            inputs.sops-nix.nixosModules.sops
          ];
          machinedir = ./system/machines;
        };
      homeConfigurations = let
        lib = (import ./user/lib.nix) {inherit nixpkgs home-manager;};
      in
        lib.mkConfigs {
          genOverlays = system: [
            nur.overlay
            inputs.mynur.overlay
            inputs.talon-nix.overlays.default
            (
              # Add packages from flake inputs to pkgs
              final: prev: {
                mum-rofi = inputs.mum-rofi.outputs.defaultPackage.${system};
                toki = inputs.toki.outputs.defaultPackage.${system};
                kubectl = inputs.krew2nix.outputs.packages.${system}.kubectl;
          repos.talon-community = inputs.talon-community;
          repos.cursorless-talon = inputs.cursorless-talon;
              }
            )
          ];
          modules = [
            inputs.sops-nix.homeManagerModule
            inputs.stylix.homeManagerModules.stylix
          ];
          nixosConfigurations = nixosConfigurations;
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
      pre-commit-sops-updatekeys = pkgs.callPackage ./pkgs/pre-commit-sops-updatekeys.nix {};
      pre-commit-nix-fmt = pkgs.callPackage ./pkgs/pre-commit-nix-fmt.nix {};
    in {
      formatter = pkgs.alejandra;
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
          git-branchless
          cachix
          inputs.disko.packages.${system}.disko
        ];
      };
    });
}
