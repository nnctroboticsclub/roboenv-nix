{ pkgs }:
pkgs.lib.makeScope pkgs.newScope (self: {
  mbed-os = self.callPackage ./mbed-os { };
  mbed-os-src = self.callPackage ./mbed-os-src { };
  mbed-os-python = self.callPackage ./mbed-os-python { };

  static-mbed-os-core = self.callPackage ./static-mbed-os-core { };
  static-mbed-os = self.callPackage ./static-mbed-os { };

  qemu-arm-xpack = self.callPackage ./qemu-arm-xpack { };

  roboPythonPackages = import ./roboPythonPackages { pkgs = self; };
})
