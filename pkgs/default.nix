{
  pkgs,
  lib,
  cPkgs,
}:

lib.makeScope pkgs.newScope (
  self:
  let
    roboPackagesSet = pkgs.callPackage ./RoboPackages { inherit cPkgs; };
  in
  {
    # rlib: 内部ライブラリ関数
    rlib = self.callPackage ./lib { };

    # パッケージグループ
    CMSIS5DevicePackages = self.callPackage ./cmsis5-device { };
    STM32HALPackages = self.callPackage ./stm32-hal { };
    StaticMbedOSPackages = self.callPackage ./static-mbed-os { };

    # スコープとして定義されるパッケージセット
    roboPythonPackages = self.callPackage ./roboPythonPackages { };
    roboPackages = roboPackagesSet;

    # Python パッケージ (roboPythonPackages から展開)
    lief_0_14_1 = self.roboPythonPackages.lief_0_14_1;
    packaging_21_3 = self.roboPythonPackages.packaging_21_3;
    click_8_0_4 = self.roboPythonPackages.click_8_0_4;
    cryptography_36_0_1 = self.roboPythonPackages.cryptography_36_0_1;
    cysecuretools_6_0_0 = self.roboPythonPackages.cysecuretools_6_0_0;
    mbed_tools = self.roboPythonPackages.mbed_tools;

    # ツールチェーンとライブラリ
    cmake-libs = self.callPackage ./cmake-libs { };
    gcc-arm-toolchain = self.callPackage ./gcc-arm-toolchain { };
    clang-arm-toolchain = self.callPackage ./clang-arm-toolchain { };
    clang-toolchain = self.callPackage ./clang-toolchain { };

    # Mbed と CMSIS
    mbed-os = self.callPackage ./mbed-os { };
    cmsis5 = self.callPackage ./cmsis5 { };

    # CMSIS5 デバイスパッケージ (CMSIS5DevicePackages から展開)
    cmsis5-device-f3 = self.CMSIS5DevicePackages.cmsis5-device-f3;
    cmsis5-device-f4 = self.CMSIS5DevicePackages.cmsis5-device-f4;

    # STM32 HAL パッケージ (STM32HALPackages から展開)
    stm32-hal-f3xx = self.STM32HALPackages.stm32-hal-f3xx;
    stm32-hal-f4xx = self.STM32HALPackages.stm32-hal-f4xx;

    # Static Mbed OS パッケージ (StaticMbedOSPackages から展開)
    static-mbed-os = self.StaticMbedOSPackages.static-mbed-os;
    static-mbed-os-f446re = self.StaticMbedOSPackages.static-mbed-os-f446re;
    static-mbed-os-f303k8 = self.StaticMbedOSPackages.static-mbed-os-f303k8;

    # エミュレータとツール
    qemu-arm-xpack = self.callPackage ./qemu-arm-xpack { };

    # roboenv 本体 (スコープ全体とライブラリ関数を渡す)
    roboenv = self.callPackage ./roboenv {
      rlib = self.rlib;
      roboenvScope = self;
    };
  }
  // roboPackagesSet # roboPackages の全パッケージをトップレベルに展開
)
