{lib}: {
  nixos = import ./nixos.nix {inherit lib;};
  homeManager = import ./homeManager.nix {inherit lib;};
  modulesFrom = modulePath:
    lib.pipe modulePath [
      builtins.readDir
      (lib.filterAttrs (
        filename: type:
          (filename != "default.nix")
          && (
            (lib.hasSuffix ".nix" filename) || (type == "directory")
          )
      ))
      (lib.mapAttrs' (
        filename: _: let
          strippedName = lib.pipe filename [(lib.removeSuffix ".nix") (lib.removePrefix "_")];
        in {
          name = "booq-${strippedName}";
          value = "${modulePath}/${filename}";
        }
      ))
    ];
  updateNoOverride = a:
    lib.foldlAttrs (
      acc: name: value:
        if lib.elem name (lib.attrNames a)
        then throw "Cannot update attribute set. Would override attribute ${name}."
        else acc // {${name} = value;}
    )
    a;
}
