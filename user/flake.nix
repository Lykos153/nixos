# Inspired https://github.com/sherubthakur/dotfiles/tree/89dd7dc0359ee0c84520fa3143f1763c326fc4d6
{
  description = "Home manager flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    mynur.url = "github:Lykos153/nur-packages";
    #mynur.inputs.nixpkgs.follows = "nixpkgs";
    get-flake.url = "github:ursi/get-flake";
    mum-rofi.url = "github:lykos153/mum-rofi";
    toki.url = "github:lykos153/toki";
    krew2nix.url = "github:lykos153/krew2nix";
    krew2nix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    talon-nix.url = "github:nix-community/talon-nix";
    talon-community.url = "github:Lykos153/talon-community";
    talon-community.flake = false;
    cursorless-talon.url = "github:cursorless-dev/cursorless-talon";
    cursorless-talon.flake = false;
    rango.url = "github:david-tejada/rango-talon";
    rango.flake = false;
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nur,
    ...
  } @ inputs: let
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
          repos.rango = inputs.rango;
        }
      )
    ];
    systemFlake = inputs.get-flake ../system;
    lib = (import ./lib.nix) {inherit nixpkgs home-manager;};
    modules = [
      inputs.sops-nix.homeManagerModule
      inputs.stylix.homeManagerModules.stylix
    ];
  in {
    homeConfigurations = lib.mkConfigs {
      inherit modules genOverlays;
      nixosConfigurations = systemFlake.outputs.nixosConfigurations;
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
