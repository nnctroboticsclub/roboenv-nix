{ lib, pkgs, ... }:

config:

let
  isClang = config.toolchain == "clang";
  isGcc = config.toolchain == "gcc";

  clangPackages = with pkgs; [
    llvmPackages_19.bintools
    llvmPackages_19.clang
    llvmPackages_19.clang-tools
    llvmPackages_19.llvm
    llvmPackages_19.libclang.lib
  ];

  gccPackages = with pkgs; [
    gcc-arm-embedded
  ];

  commonPackages = with pkgs; [
    cmake
    ccache
    ninja
    gcc-arm-embedded
  ];

  toolchainPackage = if isClang then pkgs.clang-arm-toolchain else pkgs.gcc-arm-toolchain;
in
{
  buildInputs =
    if config.enable then
      commonPackages
      ++ (if isClang then clangPackages else [ ])
      ++ (if isGcc then gccPackages else [ ])
      ++ [
        toolchainPackage
      ]
    else
      [ ];

  shellHook =
    if config.enable then
      ''
        # C/C++ environment setup
        ${lib.optionalString isClang ''
          export LIBCLANG_PATH="${pkgs.llvmPackages_19.libclang.lib}/lib"
        ''}
        export CMAKE_MODULE_PATH="''${CMAKE_MODULE_PATH:+$CMAKE_MODULE_PATH:}${toolchainPackage}/lib/cmake"
        export CMAKE_PREFIX_PATH="''${CMAKE_PREFIX_PATH:+$CMAKE_PREFIX_PATH:}${toolchainPackage}/lib/cmake"
      ''
    else
      "";
}
