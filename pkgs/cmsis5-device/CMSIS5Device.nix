{
  rlib,
  cmake,

  cmake-libs,
  gcc-arm-toolchain,
  cmsis5,
}:
{
  src,
  pname,
  build-target,
}:
rlib.buildCMakeProject {
  pname = pname;
  version = "0.1.0";

  src = ./.;

  cmakeFlags = [
    "-DSourceTree=${src}"
    "-DBuildTarget=${build-target}"
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
