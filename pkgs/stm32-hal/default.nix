{
  callPackage,
  cmsis5-device-f3,
  cmsis5-device-f4,
  cLibs,
}:
let
  STM32HAL = callPackage ./STM32HAL.nix { };
in
{
  stm32-hal-f3xx = STM32HAL {
    linker_script = ./STM32F303K8TX_FLASH.ld;
    target = "F3xx";
    dependencies = "CMSIS5::Device::F3";
    cmakeBuildInputs = [ cmsis5-device-f3 ];
    src = cLibs.stm32f3xx-hal-driver;
  };
  stm32-hal-f4xx = STM32HAL {
    linker_script = ./STM32F446RETX_FLASH.ld;
    target = "F4xx";
    dependencies = "CMSIS5::Device::F4";
    cmakeBuildInputs = [ cmsis5-device-f4 ];
    src = cLibs.stm32f4xx-hal-driver;
  };
}
