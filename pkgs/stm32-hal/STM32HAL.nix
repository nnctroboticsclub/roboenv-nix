{ lib, stdenv }:
{
  linker_script,
  target,
  dependencies,
  cmakeBuildInputs,
  src,
}:
stdenv.mkDerivation {
  pname = "stm32${lib.toLower target}-hal";
  inherit cmakeBuildInputs;

  version = "0.2.0";

  src = ./.;

  buildPhase = ''
    export HAL_LD=$out/lib/cmake/STM32HAL${target}/STM32HAL${target}.ld
    export HAL_ROOT=${src}
    export HAL_DEPENDENCIES='${dependencies}'
    export LIB_NAME=STM32HAL${target}

    bash $src/cmake/STM32HALConfig.sh ${dependencies}> STM32HALConfig.cmake
  '';
  installPhase = ''
    mkdir -p $out/lib/cmake/STM32HAL${target}

    cp ${linker_script} $out/lib/cmake/STM32HAL${target}/STM32HAL${target}.ld
    cp STM32HALConfig.cmake $out/lib/cmake/STM32HAL${target}/STM32HAL${target}Config.cmake
  '';
}
