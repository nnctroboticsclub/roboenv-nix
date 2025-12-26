{
  stdenv,
  llvmPackages_19,
  gcc-arm-embedded,
}:
let
  drv = stdenv.mkDerivation {
    pname = "clang-arm-toolchain";
    version = "0.2.0";

    src = ./.;

    cmakeBuildInputs = [ ]; # Mark as CMakePackage

    buildPhase = ''
      echo "Building Clang Arm Toolchain"
      cat $src/ClangArmToolchain.cmake \
        | sed \
            -e 's|@ArmToolchainDir@|${gcc-arm-embedded}|g' \
            -e 's|@ClangRootDir@|${llvmPackages_19.clang-unwrapped}|g' \
        > ClangArmToolchain.cmake \
        || echo "Error processing ClangArmToolchain.cmake"
    '';

    installPhase = ''
      mkdir -p $out/lib/cmake
      cp ClangArmToolchain.cmake $out/lib/cmake/ClangArmToolchain.cmake

      f=$out/lib/cmake/ClangArmToolchain.cmake
      if cat $f | grep "set(CMAKE_C_COMPILER"; then
        echo "CMAKE_C_COMPILER found in $f"
      else
        echo "CMAKE_C_COMPILER not found in $f"
        exit 1
      fi
    '';
  };
in
drv
