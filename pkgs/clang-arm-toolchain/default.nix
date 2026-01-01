{
  stdenv,
  llvmPackages_21,
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

      CXX_VERSION=$(ls ${gcc-arm-embedded}/arm-none-eabi/include/c++/ | head -1)

      cat $src/ClangArmToolchain.cmake \
        | sed \
            -e 's|@ArmToolchainDir@|${gcc-arm-embedded}|g' \
            -e 's|@ClangRootDir@|${llvmPackages_21.clang-unwrapped}|g' \
            -e "s|@CXXVersion@|$CXX_VERSION|g" \
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
