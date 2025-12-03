{
  pkgs,
  rlib,
  rpkgs,
}:
let
  lib_pkgs = [
    rpkgs.static-mbed-os-f303k8
    rpkgs.static-mbed-os-f446re
    rpkgs.stm32-hal-f3xx
    rpkgs.stm32-hal-f4xx

    rpkgs.ikarashiCAN_mk2
    rpkgs.ikakoMDC
    rpkgs.ikako_rohm_md
    rpkgs.MotorController

    rpkgs.IkakoRobomas
    rpkgs.can_servo
    rpkgs.Futaba_Puropo
    rpkgs.PS4_RX

    rpkgs.club-legacy-libs
  ];
  roboPkg = pkgs.symlinkJoin {
    name = "roboenv";
    paths = builtins.concatLists (map rlib.collectCMakePackages lib_pkgs);
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    clang
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
    stlink

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

  CMAKE_PREFIX_PATH = "${roboPkg}/lib/cmake";
  CMAKE_MODULE_PATH = "${roboPkg}/lib/cmake";
}
