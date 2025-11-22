{
  rlib,
  cmake,

  cmake-libs,
  gcc-arm-toolchain,
  cmsis5,
}:
let
  cmsis-device-f4-src = builtins.fetchGit {
    url = "https://github.com/STMicroelectronics/cmsis-device-f4.git";
    rev = "3c77349ce04c8af401454cc51f85ea9a50e34fc1";
  };
in
rlib.buildCMakeProject {
  pname = "cmsis5-device-f4";
  version = "0.1.0";

  src = ./.;

  cmakeFlags = [
    "-DSourceTree=${cmsis-device-f4-src}"
  ];

  cmakeBuildInputs = [
    gcc-arm-toolchain
    cmsis5
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
