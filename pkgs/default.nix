final: prev:
let
  CMSIS5DevicePackages = final.callPackage ./cmsis5-device { };
  STM32HALPackages = final.callPackage ./stm32-hal { };
  StaticMbedOSPackages = final.callPackage ./static-mbed-os { };
in
{
  roboPythonPackages = final.callPackage ./roboPythonPackages { };
  roboPackages = final.callPackage ./RoboPackages { };

  rlib = final.callPackage ./lib { };

  cmake-libs = final.callPackage ./cmake-libs { };
  gcc-arm-toolchain = final.callPackage ./gcc-arm-toolchain { };
  clang-arm-toolchain = final.callPackage ./clang-arm-toolchain { };

  mbed-os = final.callPackage ./mbed-os { };
  cmsis5 = final.callPackage ./cmsis5 { };

  inherit (CMSIS5DevicePackages) cmsis5-device-f3 cmsis5-device-f4;
  inherit (STM32HALPackages) stm32-hal-f3xx stm32-hal-f4xx;
  inherit (StaticMbedOSPackages) static-mbed-os static-mbed-os-f446re static-mbed-os-f303k8;

  qemu-arm-xpack = final.callPackage ./qemu-arm-xpack { };
}
