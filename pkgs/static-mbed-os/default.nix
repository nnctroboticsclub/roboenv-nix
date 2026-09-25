{
  rlib,

  cmake-libs,
  gcc-arm-toolchain,

  mbed-os,
}:
let
  static-mbed-os =
    {
      pname,
      mbedTarget,
    }:
    rlib.buildCMakeProject {
      inherit pname;
      version = "1.0.4";

      src = ./.;

      cmakeFlags = [
        "-DCMAKE_BUILD_TYPE=Develop"
        "-DMBED_TARGET=${mbedTarget}"
        "-DTOOLCHAIN_MODE=GNU"
      ];

      cmakeBuildInputs = [
        gcc-arm-toolchain
        cmake-libs
        mbed-os
      ];

      nativeBuildInputs = [
        mbed-os
        mbed-os.pythonEnv
      ];
    };
in
{
  inherit static-mbed-os;

  static-mbed-os-f446re = static-mbed-os {
    pname = "static-mbed-os-f446re";
    mbedTarget = "NUCLEO_F446RE";
  };

  static-mbed-os-f303k8 = static-mbed-os {
    pname = "static-mbed-os-f303k8";
    mbedTarget = "NUCLEO_F303K8";
  };
}
