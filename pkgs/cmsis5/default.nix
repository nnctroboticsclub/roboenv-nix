{
  stdenv,
  cmake,

  cmake-libs,
  gcc-arm-toolchain,
}:
let
  cmsis5-src = builtins.fetchGit {
    url = "https://github.com/ARM-software/CMSIS_5";
    ref = "5.9.0";
    rev = "2b7495b8535bdcb306dac29b9ded4cfb679d7e5c";
  };
in

stdenv.mkDerivation {
  pname = "CMSIS5";
  version = "0.1.0";

  src = ./.;

  cmakeFlags = [
    "-DCMSIS5_DIR=${cmsis5-src}"
  ];

  cmakeBuildInputs = [
    gcc-arm-toolchain
  ];

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    gcc-arm-toolchain
    cmake-libs
  ];

  # Ensure that dependent packages can find the CMake modules
  postInstall = ''
    mkdir -p $out/nix-support
    echo "export CMAKE_MODULE_PATH=\''${CMAKE_MODULE_PATH:+\$CMAKE_MODULE_PATH:}$out/lib/cmake" >> $out/nix-support/setup-hook
  '';

  # Debug
  buildFlags = [ "VERBOSE=1" ];
}
