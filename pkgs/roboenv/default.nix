{
  lib,
  pkgs,
  rlib,
  ...
}:

config:

let
  # C/C++ toolchain module
  c_cppModule = import ./modules/c_cpp.nix { inherit lib pkgs; };

  # Rust module
  rustModule = import ./modules/rust.nix { inherit lib pkgs; };

  # STM32 module
  stm32Module = import ./modules/stm32.nix { inherit lib pkgs; };

  # Frameworks module
  frameworksModule = import ./modules/frameworks.nix { inherit lib pkgs rlib; };

  # Libraries module
  librariesModule = import ./modules/libraries.nix { inherit lib pkgs rlib; };

  # デフォルト設定
  defaults = {
    name = "roboenv";
    c_cpp = {
      enable = false;
      toolchain = "gcc";
    };
    rust = {
      enable = false;
    };
    STM32 = {
      enable = false;
      emulator = null;
    };
    frameworks = [ ];
    libraries = [ ];
    extraBuildInputs = _: [ ];
  };

  # 設定をマージ
  mergedConfig = lib.recursiveUpdate defaults config;

  # 各モジュールを評価
  c_cppEnv = c_cppModule mergedConfig.c_cpp;
  rustEnv = rustModule mergedConfig.rust;
  stm32Env = stm32Module mergedConfig.STM32;
  frameworksEnv = frameworksModule mergedConfig.frameworks;
  librariesEnv = librariesModule mergedConfig.libraries;

  # すべてのモジュールの結果をマージ
  allEnvs = [
    c_cppEnv
    rustEnv
    stm32Env
    frameworksEnv
    librariesEnv
  ];

  # buildInputs を結合
  buildInputs = lib.flatten (map (env: env.buildInputs or [ ]) allEnvs);

  # shellHook を結合
  shellHook = lib.concatStringsSep "\n" (map (env: env.shellHook or "") allEnvs);

  # extraBuildInputs を追加
  extraInputs = mergedConfig.extraBuildInputs pkgs;

in
pkgs.mkShell {
  name = mergedConfig.name;
  buildInputs = buildInputs ++ extraInputs ++ [ pkgs.ccache ];
  inherit shellHook;

  CCACHE_COMPRESS = 1;
    CCACHE_SLOPPINESS = "random_seed";
    CCACHE_DIR = "/nix/var/cache/ccache";
    CCACHE_UMASK = "007";
}
