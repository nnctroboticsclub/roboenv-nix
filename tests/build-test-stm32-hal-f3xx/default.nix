{
  cmake,

  stm32-hal-f3xx,
  buildCMakeProject,
}:
buildCMakeProject {
  pname = "test-stm32-hal-f3xx";
  version = "0.1.0";
  src = ./.;

  cmakeBuildInputs = [ stm32-hal-f3xx ];
  nativeBuildInputs = [ stm32-hal-f3xx ];
  buildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_TOOLCHAIN_FILE=STM32HALF3xxToolchain"
  ];
  noInstall = true;

  # Enable verbose build for debugging
  ninjaFlags = [ "-v" ];
  makeFlags = [ "VERBOSE=1" ];
}
