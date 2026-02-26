{
  callPackage,
  cmsis5-device-f3,
  cmsis5-device-f4,
  fetchgit,
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
    src = fetchgit {
      url = "https://github.com/STMicroelectronics/stm32f3xx-hal-driver.git";
      rev = "ef8c84f93e990805571c056f206538793d011542";
      sha256 = "sha256-ALozMQFB354RSXHxkHNEroNbjfIi4cSHuCjxclXeLTk=";
    };
  };
  stm32-hal-f4xx = STM32HAL {
    linker_script = ./STM32F446RETX_FLASH.ld;
    target = "F4xx";
    dependencies = "CMSIS5::Device::F4";
    cmakeBuildInputs = [ cmsis5-device-f4 ];
    src = fetchgit {
      url = "https://github.com/STMicroelectronics/stm32f4xx-hal-driver.git";
      rev = "edad1a8a23ec4d7d287df60f0992ca395c85395c";
      sha256 = "sha256-CynoM96Rr4/Gb55Ci4t/aIhn6FrtxivxsWJy6eKcDdA=";
    };
  };
}
