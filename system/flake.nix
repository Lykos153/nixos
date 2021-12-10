{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    {
        nixosConfigurations = {
            # TODO: Learn how to do that more elegantly, eg. https://www.reddit.com/r/NixOS/comments/jktqpg/choosing_imported_configurations_based_on_a/
            pc = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [ ./configuration.nix ./hardware.d/pc.nix ];
            };
            stick = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [ ./configuration.nix ./hardware.d/stick.nix ];
            };
            lenovo-yoga = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [ ./configuration.nix ./hardware.d/lenovo-yoga.nix ];
            };
        };
    };
}