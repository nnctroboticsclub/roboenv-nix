{
  gcc-arm-embedded,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "gcc-arm-toolchain";
  version = "0.1.0";

  src = ./.;

  cmakeBuildInputs = [
    gcc-arm-embedded
  ]; # Mark as CMake package

  buildPhase =
    let
      prefix = "${gcc-arm-embedded}/bin/arm-none-eabi";
    in
    ''
      cat <<EOF > GccArmToolchain.cmake
      set(CMAKE_SYSTEM_NAME Generic)
      set(CMAKE_SYSTEM_PROCESSOR arm)

      set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

      set(CMAKE_C_COMPILER "${prefix}-gcc")
      set(CMAKE_CXX_COMPILER "${prefix}-g++")
      set(CMAKE_ASM_COMPILER "${prefix}-gcc")
      set(CMAKE_OBJCOPY "${prefix}-objcopy")
      set(CMAKE_OBJDUMP "${prefix}-objdump")
      set(CMAKE_SIZE "${prefix}-size")
      set_property(GLOBAL PROPERTY ELF2BIN "${prefix}-objcopy")

      set(USING_TOOLCHAIN "GNU")
      EOF
    '';

  installPhase = ''
    mkdir -p $out/lib/cmake

    cp GccArmToolchain.cmake $out/lib/cmake
  '';
}
