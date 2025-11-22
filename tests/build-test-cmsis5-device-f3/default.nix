{
  cmake,

  cmsis5-device-f3,
  buildCMakeProject,
}:
buildCMakeProject {
  pname = "test-cmsis5-device-f3";
  version = "0.1.0";
  src = ./.;

  cmakeBuildInputs = [ cmsis5-device-f3 ];
  nativeBuildInputs = [ cmsis5-device-f3 ];
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
