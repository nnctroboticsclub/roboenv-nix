{
  cmake,

  cmsis-device-f3,
  cmsis5,
  static-mbed-os-f446re,
  buildCMakeProject,
}:
{
  test-smbed = import ./build-test {
    inherit cmake static-mbed-os-f446re buildCMakeProject;
  };
  test-cmsis-device-f3 = import ./build-test-cmsis-device-f3 {
    inherit cmake cmsis-device-f3 buildCMakeProject;
  };
  test-cmsis5 = import ./build-test-cmsis5 {
    inherit cmake cmsis5 buildCMakeProject;
  };
}
