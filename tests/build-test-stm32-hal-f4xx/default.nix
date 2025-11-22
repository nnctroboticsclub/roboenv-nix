{
  cmake,

  stm32-hal-f4xx,
  buildCMakeProject,
}:
buildCMakeProject {
  pname = "test-stm32-hal-f4xx";
  version = "0.1.0";
  src = ./.;

  cmakeBuildInputs = [ stm32-hal-f4xx ];
  nativeBuildInputs = [ stm32-hal-f4xx ];
  buildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_TOOLCHAIN_FILE=STM32HALF4xxToolchain"
  ];
  noInstall = true;

  # Enable verbose build for debugging
  ninjaFlags = [ "-v" ];
  makeFlags = [ "VERBOSE=1" ];
}
