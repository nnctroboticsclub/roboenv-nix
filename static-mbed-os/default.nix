{
  # nixpkgs
  callPackage,
  python311,
  python311Packages,

  cmake-libs,
  gcc-arm-toolchain,
}:
let
  mbed-os_pkgs = callPackage ./mbed-os/default.nix {
    url = "https://github.com/mbed-ce/mbed-os.git";
    ref = "master";
    rev = "4ba00162ba2d73c64583018983391e1dfeaee83d";
  };

  mbed-ce-python = python311Packages.callPackage ./mbed-ce-python-env/default.nix {
    inherit (mbed-os_pkgs) mbed-os-src;
    withPackages = python311.withPackages;
  };

  static-mbed-os-core = callPackage ./pack-core/default.nix { };

  makeStaticMBedOS = callPackage ./static-mbed-os/default.nix {
    inherit mbed-ce-python;
    inherit static-mbed-os-core;

    inherit (mbed-os_pkgs) mbed-os;

    inherit cmake-libs;
    inherit gcc-arm-toolchain;
  };
in
{
  static-mbed-os-core = callPackage ./pack-core/default.nix { };

  static-mbed-os-f446re = makeStaticMBedOS {
    pname = "static-mbed-os-f446re";
    mbedTarget = "NUCLEO_F446RE";
  };

  static-mbed-os-f303k8 = makeStaticMBedOS {
    pname = "static-mbed-os-f303k8";
    mbedTarget = "NUCLEO_F303K8";
  };
}
