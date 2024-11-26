{
  lib,
  fetchurl,
  linux_testing,
  src,
  ...
} @ args:
linux_testing.override {
  argsOverride = rec {
    inherit src;
    version = "6.13-custom-bcachefs";
    modDirVersion = "6.13.0-rc3";
  };
}
