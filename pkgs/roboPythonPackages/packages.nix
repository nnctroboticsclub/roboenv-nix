pkgs: {
  lief_0_14_1 = pkgs.callPackage ./lief_0_14_1.nix;
  packaging_21_3 = pkgs.callPackage ./packaging_21_3.nix;
  click_8_0_4 = pkgs.callPackage ./click_8_0_4.nix;
  cryptography_36_0_1 = pkgs.callPackage ./cryptography_36_0_1.nix;
  setuptools_69_5_1 = pkgs.callPackage ./setuptools_69_5_1.nix;
  prettytable_3_12_0 = pkgs.callPackage ./prettytable_3_12_0.nix;
  cysecuretools_6_0_0 = pkgs.callPackage ./cysecuretools_6_0_0.nix;
  mbed_tools = pkgs.callPackage ./mbed_tools.nix;
}
