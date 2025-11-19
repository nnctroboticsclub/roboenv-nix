{ pkgs, rpkgs }:
pkgs.mkShell {
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
    rpkgs.qemu-arm-xpack
  ];
  RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

  CMAKE_MODULE_PATH =
    let
      roboPkgs = [
        rpkgs.cmake-libs
        rpkgs.gcc-arm-toolchain
        rpkgs.static-mbed-os-f303k8
        rpkgs.static-mbed-os-f446re
      ];
    in
    pkgs.lib.concatStringsSep ";" (map (p: "${p}/lib/cmake") roboPkgs);
}
