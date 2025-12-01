{ pkgs, rlib }:
let
  basePkgs = pkgs;
  roboPythonPackages = import ./roboPythonPackages { pkgs = basePkgs; };
in
basePkgs.lib.makeScope basePkgs.newScope (
  self:
  let
    static-mbed-os-packages = self.callPackage ./static-mbed-os { };
    CMSIS5DevicePackages = self.callPackage ./cmsis5-device { };
    STM32HALPackages = self.callPackage ./stm32-hal { };
    RoboPackages = self.callPackage ./RoboPackages { };
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

    inherit (CMSIS5DevicePackages) cmsis5-device-f3 cmsis5-device-f4;
    inherit (STM32HALPackages) stm32-hal-f3xx stm32-hal-f4xx;
    inherit (RoboPackages)
      ikarashiCAN_mk2
      ikakoMDC
      ikako_rohm_md
      MotorController
      ;
    inherit (RoboPackages)
      IkakoRobomas
      can_servo
      Futaba_Puropo
      PS4_RX
      ;

    static-mbed-os-core = self.callPackage ./static-mbed-os-core { };
    inherit (static-mbed-os-packages) static-mbed-os-f446re static-mbed-os-f303k8;

    qemu-arm-xpack = self.callPackage ./qemu-arm-xpack { };
  }
)
