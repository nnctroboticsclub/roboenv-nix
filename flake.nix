{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/25.05";

  inputs.libs-cmake.url = "github:nnctroboticsclub/libs-cmake";
  inputs.libs-cmake.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      nixpkgs,
      libs-cmake,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      cmake-libs = libs-cmake.packages.${system}.libs-cmake;
      gcc-arm-toolchain = libs-cmake.packages.${system}.gcc-arm-toolchain;
      lib = pkgs.callPackage ./lib { };
      collectCMakePackages = lib.collectCMakePackages;
      buildCMakeProject = lib.buildCMakeProject;
      mbed-os-f446re = spkgs.static-mbed-os-f446re;
      mbed-os-f303k8 = spkgs.static-mbed-os-f303k8;
      spkgs = pkgs.callPackage ./static-mbed-os {
        inherit cmake-libs;
        inherit gcc-arm-toolchain;
      };
      tpkgs = pkgs.callPackage ./tests {
        inherit (spkgs) static-mbed-os-f446re;
        inherit buildCMakeProject;
      };
    in
    rec {
      packages.x86_64-linux.cmake-libs = cmake-libs;
      packages.x86_64-linux.gcc-arm-toolchain = gcc-arm-toolchain;
      packages.x86_64-linux.static-mbed-os-f446re = mbed-os-f446re;
      packages.x86_64-linux.static-mbed-os-f303k8 = mbed-os-f303k8;
      packages.x86_64-linux.test-smbed = tpkgs.test-smbed;
      packages.x86_64-linux.qemu-arm-xpack = pkgs.callPackage ./pkgs/qemu-arm-xpack.nix { };

      lib.collectCMakePackages = collectCMakePackages;
      lib.buildCMakeProject = buildCMakeProject;

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          clang-tools

          cargo
          rust-analyzer
          pkg-config
          udev
          rustfmt
          rustc
          clippy
          ccache
          dpkg
          ninja
          stlink-tool

          git-conventional-commits

          nix-output-monitor

          #* Migrated from robotics container
          # Tools
          gcc-arm-embedded-14
          cmake
          go-task
          packages.x86_64-linux.qemu-arm-xpack
          # Libs
          # mbed-os-f446re
          # mbed-os-f303k8
        ];
        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
      };
    };
}
