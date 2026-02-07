{
  rlib,
  cmake,
  cLibs,

  cmake-libs,
  gcc-arm-toolchain,
}:
rlib.buildCMakeProject {
  pname = "CMSIS5";
  version = "0.1.0";

  src = ./.;

  cmakeFlags = [
    "-DCMSIS5_DIR=${cLibs.cmsis5}"
  ];

  cmakeBuildInputs = [
    gcc-arm-toolchain
  ];

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    gcc-arm-toolchain
    cmake-libs
  ];
}
