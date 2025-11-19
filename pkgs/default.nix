{ pkgs }:
let
  basePkgs = pkgs;
  roboPythonPackages = import ./roboPythonPackages { pkgs = basePkgs; };
in
basePkgs.lib.makeScope basePkgs.newScope (
  self:
  let
    static-mbed-os-packages = self.callPackage ./static-mbed-os { };
  in
  {
    inherit (basePkgs) cmake-libs gcc-arm-toolchain;
    inherit roboPythonPackages;

    mbed-os = self.callPackage ./mbed-os { };
    mbed-os-src = self.callPackage ./mbed-os-src { };
    mbed-os-python = self.callPackage ./mbed-os-python { };

    static-mbed-os-core = self.callPackage ./static-mbed-os-core { };
    inherit (static-mbed-os-packages) static-mbed-os-f446re static-mbed-os-f303k8;

    qemu-arm-xpack = self.callPackage ./qemu-arm-xpack { };
  }
)
