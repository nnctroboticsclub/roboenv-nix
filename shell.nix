# Cachix にフルキャッシュを置くための全機能を有効化したシェル環境
{ roboenv }:
roboenv {
  # DevShell の名前
  name = "NHK2025A";

  # 使用する C++ コンパイラ (デフォルト: "gcc")
  # - c_cpp.enable
  #   - cmake, ninja
  #   - CMAKE_PREFIX_PATH, CMAKE_MODULE_PATH を設定
  # - c_cpp.toolchain = 'clang'
  #   - bintools, clang, clang-tools, llvm, libclang
  #   - LIBCLANG_PATH を設定
  # - c_cpp.toolchain = 'gcc'
  #   - gcc-arm-embedded
  c_cpp.enable = true;
  c_cpp.toolchain = "clang";

  # Rust を使用する場合は true に設定 (デフォルト: false)
  # - rust (thumbv7em-none-eabi)
  # - rust-analyzer, rustfmt, rustc, clippy, cbindgen
  # - pkg-config udev
  # - RUST_SRC_PATH を設定
  rust.enable = true;

  # STM32 開発環境
  # stlink を追加
  STM32.enable = true;
  # STM32 エミュレータ (デフォルト: null)
  STM32.emulator = "qemu-arm-xpack";

  tool.usb.enable = true;

  # 利用するフレームワークの設定
  # - {type: "StaticMbedCE", mbedTarget: "..."}
  # - {type: "STM32HAL", family: "f3" | "f4"} [未定義]
  frameworks = [
    {
      type = "StaticMbedOS";
      mbedTarget = "NUCLEO_F446RE";
    }
    {
      type = "StaticMbedOS";
      mbedTarget = "NUCLEO_F303K8";
    }
    {
      type = "STM32HAL";
      family = "f4";
    }
    {
      type = "STM32HAL";
      family = "f3";
    }
  ];

  libraries = [
  ];

  # 追加のビルド入力 (これに限り default.nix で処理される)
  extraBuildInputs =
    pkgs: with pkgs; [
      git-conventional-commits
      graphviz
      go-task
    ];
}
