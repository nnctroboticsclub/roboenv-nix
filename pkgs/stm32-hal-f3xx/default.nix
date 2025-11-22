{
  stdenv,
  cmsis5-device-f3,
}:
let
  stm32f3xx-hal-src = builtins.fetchGit {
    url = "https://github.com/STMicroelectronics/stm32f3xx-hal-driver.git";
    rev = "ef8c84f93e990805571c056f206538793d011542";
  };
in
stdenv.mkDerivation {
  pname = "stm32f3xx-hal";
  version = "0.1.0";

  src = ./.;

  cmakeBuildInputs = [
    cmsis5-device-f3
  ];

  buildPhase = ''
    cat << EOF > STM32HALF3xx-Locator.cmake
    set(HAL_ROOT "${stm32f3xx-hal-src}")
    EOF
  '';
  installPhase = ''
    mkdir -p $out/lib/cmake

    cp STM32HALF3xx-Locator.cmake $out/lib/cmake
    cp $src/STM32F303K8TX_FLASH.ld $out/lib/cmake
    cp $src/STM32HALF3xxConfig.cmake $out/lib/cmake
    cp $src/STM32HALF3xxToolchain.cmake $out/lib/cmake
  '';
}
