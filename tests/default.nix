{
  cmake,

  static-mbed-os-f446re,
  cmsis5-device-f3,
  cmsis5-device-f4,
  cmsis5,
  stm32-hal-f3xx,
  buildCMakeProject,
}:
{
  test-smbed = import ./build-test {
    inherit cmake static-mbed-os-f446re buildCMakeProject;
  };
  test-cmsis5-device-f3 = import ./build-test-cmsis5-device-f3 {
    inherit cmake cmsis5-device-f3 buildCMakeProject;
  };
  test-cmsis5-device-f4 = import ./build-test-cmsis5-device-f4 {
    inherit cmake cmsis5-device-f4 buildCMakeProject;
  };
  test-cmsis5 = import ./build-test-cmsis5 {
    inherit cmake cmsis5 buildCMakeProject;
  };
  test-stm32-hal-f3xx = import ./build-test-stm32-hal-f3xx {
    inherit cmake stm32-hal-f3xx buildCMakeProject;
  };
}
