{
  lib,
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
    structuredExtraConfig = with lib.kernel; {
      BCACHEFS_FS = yes;
    };
    extraConfig = ''
    '';

    extraMeta.branch = "master";
  }
  // (args.argsOverride or {}))
