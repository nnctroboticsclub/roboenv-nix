{
  lib,
  stdenv,
  cmsis5-device-f3,
}:
{
  linker_script ? ./STM32F303K8TX_FLASH.ld,
  target ? "F3xx",
  dependencies ? "CMSIS5::Device::F3",
  cmakeBuildInputs ? [ cmsis5-device-f3 ],
  src ? builtins.fetchGit {
    url = "https://github.com/STMicroelectronics/stm32f3xx-hal-driver.git";
    rev = "ef8c84f93e990805571c056f206538793d011542";
  },
}:
stdenv.mkDerivation {
  pname = "stm32${lib.toLower target}-hal";
  inherit cmakeBuildInputs;

  version = "0.2.0";

  src = ./.;

  buildPhase = ''
    export HAL_LD=$out/lib/cmake/STM32HAL${target}.ld
    export HAL_ROOT=${src}
    export HAL_DEPENDENCIES='${dependencies}'

    bash $src/cmake/STM32HALConfig.sh ${dependencies}> STM32HALConfig.cmake
  '';
  installPhase = ''
    mkdir -p $out/lib/cmake

    cp ${linker_script} $out/lib/cmake/STM32HAL${target}.ld
    cp STM32HALConfig.cmake $out/lib/cmake/STM32HAL${target}Config.cmake
  '';
}
