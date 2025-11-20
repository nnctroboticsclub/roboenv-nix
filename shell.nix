{ pkgs, rpkgs }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    clang-tools

    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" ];
      targets = [ "thumbv7em-none-eabi" ];
    })
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

    graphviz
    nix-tree

    #* Migrated from robotics container
    # Tools
    gcc-arm-embedded-14
    cmake
    go-task
    rust-cbindgen
    rpkgs.qemu-arm-xpack

    pkgs.llvmPackages.libclang.lib
  ];

  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

  RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

  CMAKE_MODULE_PATH =
    let
      roboPkgs = [
        rpkgs.cmake-libs
        rpkgs.gcc-arm-toolchain
        rpkgs.static-mbed-os-f303k8
        rpkgs.static-mbed-os-f446re
        rpkgs.club-legacy-libs
      ];
    in
    pkgs.lib.concatStringsSep ";" (map (p: "${p}/lib/cmake") roboPkgs);
}
