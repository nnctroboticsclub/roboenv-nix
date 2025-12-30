{
  config,
  lib,
  pkgs,
  ...
}:
let
  cmake-loader = pkgs.stdenv.mkDerivation {
    name = "roboenv-cmake-loader";
    src = ./.;
    installPhase = ''
      mkdir -p $out/lib/cmake
      cp $src/Roboenv.cmake $out/lib/cmake/
    '';
  };
in
{
  options.c_cpp = {
    enable = lib.mkEnableOption "C/C++ toolchain support";

    cache = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "ccache" ]);
      default = "ccache";
      description = "The caching tool to use for C/C++ compilation";

    };

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
      pkgs.llvmPackages_19.bintools
      pkgs.llvmPackages_19.clang
      pkgs.llvmPackages_19.clang-tools
      pkgs.llvmPackages_19.llvm
      pkgs.llvmPackages_19.libclang.lib
    ])
    ++ (lib.optionals (config.c_cpp.toolchain == "gcc") [
      pkgs.gcc-arm-embedded
    ])
    ++ (lib.optionals (config.c_cpp.cache == "ccache") [
      pkgs.ccache
    ]);

    cmakeInputs = [
      cmake-loader
    ]
    ++ (lib.optionals (config.c_cpp.toolchain == "clang") [
      pkgs.clang-arm-toolchain
    ])
    ++ (lib.optionals (config.c_cpp.toolchain == "gcc") [
      pkgs.gcc-arm-toolchain
    ]);

    env.LIBCLANG_PATH = lib.optionalString (
      config.c_cpp.toolchain == "clang"
    ) "${pkgs.llvmPackages_19.libclang.lib}/lib";

    env.CCACHE_COMPRESS = lib.optionalString (config.c_cpp.cache == "ccache") "1";
    env.CCACHE_SLOPPINESS = lib.optionalString (config.c_cpp.cache == "ccache") "random_seed";
    env.CCACHE_DIR = lib.optionalString (config.c_cpp.cache == "ccache") "/nix/var/cache/ccache";
    env.CCACHE_UMASK = lib.optionalString (config.c_cpp.cache == "ccache") "007";

    env.CMAKE_TOOLCHAIN_FILE = "${cmake-loader}/lib/cmake/Roboenv.cmake";
  };
}
