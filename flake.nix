{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,
      ...
    }:
    let
      system = "x86_64-linux";

      importable = args: import ./pkgs args;

    in
    {
      # legacyPackages: すべてのパッケージ（遅延評価）
      legacyPackages.${system} = importable {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };
        lib = nixpkgs.lib;
      };

      # packages: よく使われる主要パッケージ
      packages.${system} =
        let
          allPackages = importable {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ rust-overlay.overlays.default ];
            };
            lib = nixpkgs.lib;
          };
        in
        {
          # ビルド可能な主要パッケージ
          inherit (allPackages)
            cmake-libs
            cmsis5
            cmsis5-device-f3
            cmsis5-device-f4
            stm32-hal-f3xx
            stm32-hal-f4xx
            static-mbed-os-f446re
            static-mbed-os-f303k8
            gcc-arm-toolchain
            clang-arm-toolchain
            qemu-arm-xpack
            mbed-os
            ;

          # roboPackages から主要なもの
          inherit (allPackages.roboPackages)
            ikarashiCAN_mk2
            ikakoMDC
            ikako_rohm_md
            MotorController
            ;
        };

      devShells.${system}.default =
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ rust-overlay.overlays.default ];
          };
          roboenvPackages = importable {
            inherit pkgs;
            lib = nixpkgs.lib;
          };
        in
        pkgs.callPackage ./shell.nix {
          inherit (roboenvPackages) roboenv roboPackages;
        };

      overlays.default =
        final: prev:
        importable {
          pkgs = final;
          lib = final.lib;
        };
    };
}
