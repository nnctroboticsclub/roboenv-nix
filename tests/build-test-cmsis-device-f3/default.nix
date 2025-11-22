{
  cmake,

  cmsis-device-f3,
  buildCMakeProject,
}:
buildCMakeProject {
  pname = "test-cmsis-device-f3";
  version = "0.1.0";
  src = ./.;

  cmakeBuildInputs = [ cmsis-device-f3 ];
  nativeBuildInputs = [ cmsis-device-f3 ];
  buildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_TOOLCHAIN_FILE=GccArmToolchain"
  ];
  noInstall = true;

  # Enable verbose build for debugging
  ninjaFlags = [ "-v" ];
  makeFlags = [ "VERBOSE=1" ];
}
