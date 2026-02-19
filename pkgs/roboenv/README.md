# roboenv Shell Generator

roboenv 関数は、Nix シェル環境を生成するためのツールです。

## 使用方法

利用例を [example.nix](./example.nix) に示します。

## 構造

Nixpkgs の Module system を用いてパラメーターを管理する。

## モジュール設計
この章では各モジュールの提供する役割とパラメータについて記載します

### base

mkShell に渡す引数を直接的に管理します
このモジュールは、主に configure することは少なく主にパラメータを保持する目的で利用します。

**提供パラメータ**
`name`: シェルの名前
`buildInputs`: シェルに追加するパッケージのリスト
`shellHook` シェル生成時に実行するスクリプト
`env`: シェルで利用する環境変数の AttrSet

`cmakeInputs`: 環境に追加するパッケージのリスト
このリストに追加されたパッケージは、 [Roboenv.cmake](./modules/Roboenv.cmake) によって `find_package` で参照することができるようになります (ただし `lib/cmake/PKG/PKGConfig.cmake` が存在する場合に限る)

`extraBuildInputs`: 追加するパッケージのリストを返す関数 (※)
この関数には nixpkgs のパッケージスコープが渡され、返されたリストを `buildInputs` として処理します

**Configure 内容**
`CMAKE_PREFIX_PATH`, `CMAKE_MODULE_PATH` に `Roboenv` や、`cmakeInputs` に追加されたパッケージのパスが追加されます。
これらの変数 `CMAKE_PREFIX_PATH`, `CMAKE_MODULE_PATH` は CMake によって自動では読み込まれません。
そのため、 [Roboenv.cmake](./modules/Roboenv.cmake) にて CMake 変数として扱えるようにしてあります。

### c_cpp

C/C++ のツールチェーンを構成します

**提供パラメータ**
`c_cpp.enable`: このモジュールの利用可否
`c_cpp.toolchain`: 利用するツールチェーン (`gcc`, `clang` のどちらか)

**Configure 内容**
`cmake`, `ninja`, `gcc-arm-embedded` がデフォルトで `buildInputs` に追加されます。
`c_cpp.toolchain` が `clang` に設定された場合以下のパッケージが追加されます
- `bintools`
- `clang`
- `llvm`
- `libclang.lib`
- `clang-tools`

また、 `cmakeInputs` に `cmake-loader` と `c_cpp.toolchain` に対応するパッケージが追加されます。
(一般的に次のいずれかです: `clang-arm-toolchain`, `gcc-arm-toolchain`)

加えて `env.CMAKE_TOOLCHAIN_FILE` に [Roboenv.cmake](./modules/Roboenv.cmake) のパスが設定されます。
この変数は CMake によって自動で読み込まれるものです。

### frameworks

`StaticMbedOS` や `STM32HAL` を構成し、`cmakeInputs` に追加します。

**提供パラメータ**
`frameworks`: フレームワーク構成の定義リストです
各要素は以下の構成のいずれかである必要があります
- `{type = "STM32HAL"; family = "F3"}
- `{type = "STM32HAL"; family = "F4"}
- `{type = "StaticMbedOS"; mbedTarget = "<MBED_TARGET に対応するボード種類 (e.g. NUCLEO_F446RE)>"}

**Configure 内容**
構成したパッケージを `cmakeInputs` に追加します。

### rust

thumbv7em-none-eabi Rust 開発環境を構成します

**提供パラメータ**
`rust.enable`: このモジュールの利用可否

**Configure 内容**
`rustc`, `rust-analyzer`, `rustfmt`, `clippy`, `cbindgen` が `buildInputs` に追加されます。
また、`RUST_SRC_PATH` が設定されます。

### stm32

STM32 の開発環境を提供します

**提供パラメータ**
`stm32.enable`: このモジュールの利用可否
`stm32.emulator`: 利用するエミュレータ (デフォルト: null)

**Configure 内容**
`buildInputs` に `stlink` とエミュレータ (e.g. `qemu-arm-xpack`) が追加されます。
