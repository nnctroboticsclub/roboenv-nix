{ pkgs, rlib }:
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
    rlib = rlib;

    inherit roboPythonPackages;

    club-legacy-libs = self.callPackage ./club-legacy-libs { };
    cmake-libs = self.callPackage ./cmake-libs { };
    gcc-arm-toolchain = self.callPackage ./gcc-arm-toolchain { };

    mbed-os = self.callPackage ./mbed-os { };
    mbed-os-src = self.callPackage ./mbed-os-src { };
    mbed-os-python = self.callPackage ./mbed-os-python { };
    cmsis5-src = self.callPackage ./cmsis5-src { };
    cmsis5 = self.callPackage ./cmsis5 { };
    cmsis5-device-f3 = self.callPackage ./cmsis5-device-f3 { };
    stm32-hal-f3xx = self.callPackage ./stm32-hal-f3xx { };
    stm32-hal-f4xx = self.callPackage ./stm32-hal-f4xx { };

    cmsis5-device-f4 = self.callPackage ./cmsis5-device-f4 { };

    static-mbed-os-core = self.callPackage ./static-mbed-os-core { };
    inherit (static-mbed-os-packages) static-mbed-os-f446re static-mbed-os-f303k8;

    qemu-arm-xpack = self.callPackage ./qemu-arm-xpack { };
  }
)
