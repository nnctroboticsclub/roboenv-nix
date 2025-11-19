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
    # Libs
    # mbed-os-f446re
    # mbed-os-f303k8
  ];
  RUST_SRC_PATH = "${rpkgs.rustPlatform.rustLibSrc}";
}
