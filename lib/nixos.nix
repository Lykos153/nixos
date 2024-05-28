let
  commonName = "_common";
in rec {
  mkHost = {
    nixpkgs,
    hostname,
    modules,
    machinedir,
  }: let
    commonpath = machinedir + "/${commonName}";
    commonmodules =
      if builtins.pathExists commonpath
      then [commonpath]
      else [];
  in
    nixpkgs.lib.nixosSystem {
      modules =
        modules
        ++ commonmodules
        ++ [
          (machinedir + "/${hostname}")
          {
            networking.hostName = hostname;
            nix.registry.nixpkgs.flake = nixpkgs; # Pin flakes so search, shell etc. are faster. From https://ianthehenry.com/posts/how-to-learn-nix/more-flakes/
            # nix.registry.nixpkgs-master.flake = nixpkgs-master;
          }
        ];
    };
  mkHosts = {
    nixpkgs,
    machinedir,
    modules,
  }:
    builtins.mapAttrs (name: _:
      mkHost {
        hostname = name;
        inherit nixpkgs machinedir modules;
      }) (nixpkgs.lib.filterAttrs (name: type: name != commonName && type == "directory") (builtins.readDir machinedir));
}
