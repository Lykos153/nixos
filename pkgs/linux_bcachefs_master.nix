{
  fetchurl,
  buildLinux,
  src,
  ...
} @ args:
buildLinux (args
  // rec {
    version = "bcachefs-master";
    modDirVersion = version;

    inherit src;

    kernelPatches = [];

    extraConfig = ''
    '';

    extraMeta.branch = "master";
  }
  // (args.argsOverride or {}))
