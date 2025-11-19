{ callPackage }:
{
  lief_0_14_1 = callPackage ./lief_0_14_1/lief_0_14_1.nix { };
  packaging_21_3 = callPackage ./packaging_21_3/packaging_21_3.nix { };
  click_8_0_4 = callPackage ./click_8_0_4/click_8_0_4.nix { };
  cryptography_36_0_1 = callPackage ./cryptography_36_0_1/cryptography_36_0_1.nix { };
  setuptools_69_5_1 = callPackage ./setuptools_69_5_1/setuptools_69_5_1.nix { };
  prettytable_3_12_0 = callPackage ./prettytable_3_12_0/prettytable_3_12_0.nix { };
  cysecuretools_6_0_0 = callPackage ./cysecuretools_6_0_0/cysecuretools_6_0_0.nix { };
  mbed_tools = callPackage ./mbed_tools/mbed_tools.nix { };
}
