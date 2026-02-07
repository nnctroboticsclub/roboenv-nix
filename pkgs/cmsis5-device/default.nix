{ callPackage, cLibs }:
let
  CMSIS5Device = callPackage ./CMSIS5Device.nix { };
in
{
  cmsis5-device-f3 = CMSIS5Device {
    src = cLibs.cmsis-device-f3;
    build-target = "F3";
    pname = "cmsis5-device-f3";
  };
  cmsis5-device-f4 = CMSIS5Device {
    src = cLibs.cmsis-device-f4;
    build-target = "F4";
    pname = "cmsis5-device-f4";
  };
}
