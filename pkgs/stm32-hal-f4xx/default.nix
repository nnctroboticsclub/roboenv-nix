{
  stdenv,
  cmsis5-device-f4,
}:
let
  stm32f4xx-hal-src = builtins.fetchGit {
    url = "https://github.com/STMicroelectronics/stm32f4xx-hal-driver.git";
    rev = "edad1a8a23ec4d7d287df60f0992ca395c85395c";
  };
in
stdenv.mkDerivation {
  pname = "stm32f4xx-hal";
  version = "0.1.0";

  src = ./.;

  cmakeBuildInputs = [
    cmsis5-device-f4
  ];

  buildPhase = ''
    cat << EOF > STM32HALF4xx-Locator.cmake
    set(HAL_ROOT "${stm32f4xx-hal-src}")
    EOF
  '';
  installPhase = ''
    mkdir -p $out/lib/cmake

    cp STM32HALF4xx-Locator.cmake $out/lib/cmake
    cp $src/STM32F446RETX_FLASH.ld $out/lib/cmake
    cp $src/STM32HALF4xxConfig.cmake $out/lib/cmake
    cp $src/STM32HALF4xxToolchain.cmake $out/lib/cmake
  '';
}
