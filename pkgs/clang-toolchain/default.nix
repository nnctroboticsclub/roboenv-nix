{
  stdenv,
  llvmPackages_21,
}:
let
  drv = stdenv.mkDerivation {
    pname = "clang-toolchain";
    version = "0.2.0";

    src = ./.;

    cmakeBuildInputs = [ ]; # Mark as CMakePackage

    buildPhase = ''
      echo "Building Clang Toolchain"
      cat $src/ClangToolchain.cmake \
        | sed \
            -e 's|@ClangRootDir@|${llvmPackages_21.clang}|g' \
        > ClangToolchain.cmake \
        || echo "Error processing ClangToolchain.cmake"
    '';

    installPhase = ''
      mkdir -p $out/lib/cmake
      cp ClangToolchain.cmake $out/lib/cmake/ClangToolchain.cmake
    '';
  };
in
drv
