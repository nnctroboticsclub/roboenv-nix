{ callPackage }:
let
  CMSIS5Device = callPackage ./CMSIS5Device.nix { };
in
{
  cmsis5-device-f3 = CMSIS5Device {
    src = builtins.fetchGit {
      url = "https://github.com/STMicroelectronics/cmsis-device-f3.git";
      ref = "v2.3.8";
      rev = "5558e64e3675a1e1fcb1c71f468c7c407c1b1134";
    };
    build-target = "F3";
    pname = "cmsis5-device-f3";
  };
  cmsis5-device-f4 = CMSIS5Device {
    src = builtins.fetchGit {
      url = "https://github.com/STMicroelectronics/cmsis-device-f4.git";
      rev = "3c77349ce04c8af401454cc51f85ea9a50e34fc1";
    };
    build-target = "F4";
    pname = "cmsis5-device-f4";
  };
}
