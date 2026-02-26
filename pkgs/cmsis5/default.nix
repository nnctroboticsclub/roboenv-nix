{
  rlib,
  cmake,

  cmake-libs,
  gcc-arm-toolchain,
  fetchgit,
}:
let
  cmsis5 = fetchgit {
    url = "https://github.com/ARM-software/CMSIS_5.git";
    rev = "2b7495b8535bdcb306dac29b9ded4cfb679d7e5c";
    sha256 = "sha256-m3V5pu/ao1d7aVhlWh0lvesAXmYA5JpOVsumAi1Wioc=";
  };
in

rlib.buildCMakeProject {
  pname = "CMSIS5";
  version = "0.1.0";

  src = ./.;

  cmakeFlags = [
    "-DCMSIS5_DIR=${cmsis5}"
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
