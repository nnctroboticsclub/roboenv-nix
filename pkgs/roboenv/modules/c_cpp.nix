{
  config,
  lib,
  pkgs,
  roboenvScope,
  ...
}:
{
  options.c_cpp = {
    enable = lib.mkEnableOption "C/C++ toolchain support";

    toolchain = lib.mkOption {
      type = lib.types.enum [
        "clang"
        "gcc"
      ];
      default = "gcc";
      description = "The C/C++ toolchain to use";
    };
  };

  config = lib.mkIf config.c_cpp.enable {
    buildInputs = [
      pkgs.cmake
      pkgs.ninja
      pkgs.gcc-arm-embedded
    ]
    ++ (lib.optionals (config.c_cpp.toolchain == "clang") [
      pkgs.llvmPackages_21.bintools
      pkgs.llvmPackages_21.clang-tools # clang-tools は clang よりも先でなければならない
      pkgs.llvmPackages_21.clang
      pkgs.llvmPackages_21.llvm
      pkgs.llvmPackages_21.libclang.lib
    ])
    ++ (lib.optionals (config.c_cpp.toolchain == "gcc") [
      pkgs.gcc-arm-embedded
    ]);

    cmakeInputs = [
      roboenvScope.roboenv-loader
    ]
    ++ (lib.optionals (config.c_cpp.toolchain == "clang") [
      roboenvScope.clang-arm-toolchain
    ])
    ++ (lib.optionals (config.c_cpp.toolchain == "gcc") [
      roboenvScope.gcc-arm-toolchain
    ]);

    env.LIBCLANG_PATH = lib.optionalString (
      config.c_cpp.toolchain == "clang"
    ) "${pkgs.llvmPackages_21.libclang.lib}/lib";

    env.CMAKE_TOOLCHAIN_FILE = "${roboenvScope.roboenv-loader}/lib/cmake/Roboenv.cmake";
  };
}
