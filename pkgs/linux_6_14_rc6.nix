{
  fetchurl,
  buildLinux,
  ...
} @ args:
buildLinux (args
  // (let
    branch = "6.14";
    suffix = "rc6";
  in rec {
    version = "${branch}.0-${suffix}";
    modDirVersion = version;

    src = fetchurl {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-${branch}-${suffix}.tar.gz";
      hash = "sha256-wPR5uEM1knyl+FsXu/s/aFcsEtpYJJ2b2VFC/iuhOV0=";
    };
    kernelPatches = [];

    extraConfig = ''
    '';

    extraMeta.branch = branch;
  })
  // (args.argsOverride or {}))
