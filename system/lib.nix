{nixpkgs}: rec {
  mkHost = {
    hostname,
    modules,
    machinedir,
  }:
    nixpkgs.lib.nixosSystem {
      modules =
        modules
        ++ [
          ./configuration.nix
          (machinedir + "/${hostname}")
          {
            networking.hostName = hostname;
            nix.registry.nixpkgs.flake = nixpkgs; # Pin flakes so search, shell etc. are faster. From https://ianthehenry.com/posts/how-to-learn-nix/more-flakes/
            # nix.registry.nixpkgs-master.flake = nixpkgs-master;
          }
        ];
    };
  mkHosts = {
    machinedir,
    modules,
  }:
    builtins.mapAttrs (name: _:
      mkHost {
        hostname = name;
        inherit machinedir modules;
      }) (builtins.readDir machinedir);
}
