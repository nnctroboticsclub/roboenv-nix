{
  stdenv,
  cmake,

  cmake-libs,
  gcc-arm-toolchain,
}:
let
  cmsis-device-f3-src = builtins.fetchGit {
    url = "https://github.com/STMicroelectronics/cmsis-device-f3.git";
    ref = "v2.3.8";
    rev = "5558e64e3675a1e1fcb1c71f468c7c407c1b1134";
  };
in
stdenv.mkDerivation {
  pname = "cmsis-device-f3";
  version = "0.1.0";

  src = ./.;

  cmakeFlags = [
    "-DSourceTree=${cmsis-device-f3-src}"
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
}
