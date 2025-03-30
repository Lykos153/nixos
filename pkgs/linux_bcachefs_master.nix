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
    version = "6.14-custom-bcachefs";
    modDirVersion = "6.14.0-rc6";
  };
}
