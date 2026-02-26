{ callPackage, fetchgit }:
let
  CMSIS5Device = callPackage ./CMSIS5Device.nix { };
in
{
  cmsis5-device-f3 = CMSIS5Device {
    src = fetchgit {
      url = "https://github.com/STMicroelectronics/cmsis-device-f3.git";
      rev = "5558e64e3675a1e1fcb1c71f468c7c407c1b1134";
      sha256 = "sha256-W4J9yrbJvQEoxn2Ic5d7uLZNXufVD0fdBRvPq/DAi5M=";
    };
    build-target = "F3";
    pname = "cmsis5-device-f3";
  };
  cmsis5-device-f4 = CMSIS5Device {
    src = fetchgit {
      url = "https://github.com/STMicroelectronics/cmsis-device-f4.git";
      rev = "3c77349ce04c8af401454cc51f85ea9a50e34fc1";
      sha256 = "sha256-Q2SKaz8jm2iBZfPCZfnAnp69hDCSShe2xJUahi4Fh+8=";
    };
    build-target = "F4";
    pname = "cmsis5-device-f4";
  };
}
