{
  stdenv,
  llvmPackages_19,
  gcc-arm-embedded,
}:
stdenv.mkDerivation {
  pname = "clang-arm-toolchain";
  version = "0.2.0";

  src = ./.;

  buildPhase = ''
    echo "Building Clang Arm Toolchain"
    cat $src/ClangArmToolchain.cmake \
      | sed \
          -e 's|@ArmToolchainDir@|${gcc-arm-embedded}|g' \
          -e 's|@ClangRootDir@|${llvmPackages_19.clang-unwrapped}|g' \
          -e 's|@LLVMRootDir@|${llvmPackages_19.llvm}|g' \
          -e 's|@ArmLinker@|${llvmPackages_19.bintools}/bin/ld.lld|g' \
      > ClangArmToolchain.cmake \
      || echo "Error processing ClangArmToolchain.cmake"
  '';

  installPhase = ''
    mkdir -p $out/lib/cmake
    cp ClangArmToolchain.cmake $out/lib/cmake/ClangArmToolchain.cmake
  '';
}
// {
  cmakeBuildInputs = [ ];
}
