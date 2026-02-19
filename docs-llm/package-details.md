# roboenv-nix パッケージ詳細

## パッケージカタログ

### ツールチェーンパッケージ

#### cmake-libs
- **説明**: CMake用の共通ライブラリとツール
- **出力**: CMake設定ファイル
- **依存**: cmake
- **用途**: 基本的なCMakeビルドサポート

#### gcc-arm-toolchain
- **説明**: GCC ARM Embedded用CMakeツールチェーンファイル
- **出力**: `GccArmToolchain.cmake`
- **設定内容**:
  - CMAKE_C_COMPILER: arm-none-eabi-gcc
  - CMAKE_CXX_COMPILER: arm-none-eabi-g++
  - CMAKE_ASM_COMPILER: arm-none-eabi-gcc
  - USING_TOOLCHAIN: "GNU"
- **依存**: gcc-arm-embedded

#### clang-arm-toolchain
- **説明**: Clang ARM用CMakeツールチェーンファイル
- **出力**: `ClangArmToolchain.cmake`
- **設定内容**:
  - CMAKE_C_COMPILER: clang (ARM向け設定)
  - CMAKE_CXX_COMPILER: clang++ (ARM向け設定)
  - USING_TOOLCHAIN: "LLVM"
- **依存**: llvmPackages_21, gcc-arm-embedded (標準ライブラリ用)
- **特徴**: テンプレート処理により動的にパス設定

#### clang-toolchain
- **説明**: ホスト向けClangツールチェーン
- **用途**: x86_64でのビルドやテスト

### CMSIS パッケージ

#### cmsis5
- **説明**: CMSIS (Cortex Microcontroller Software Interface Standard) v5
- **出力**: CMake Config ファイルとヘッダ
- **ソース**: ARM-software/CMSIS_5
- **ビルド方法**: buildCMakeProject
- **依存**: gcc-arm-toolchain, cmake-libs

#### cmsis5-device-f3
- **説明**: STM32F3シリーズ用CMSISデバイスヘッダとスタートアップコード
- **出力**: CMakeターゲット `CMSIS5::Device::F3`
- **ソース**: STMicroelectronics/cmsis-device-f3
- **含まれるもの**:
  - デバイスヘッダ (stm32f3xx.h等)
  - スタートアップファイル
  - システム初期化コード

#### cmsis5-device-f4
- **説明**: STM32F4シリーズ用CMSISデバイスヘッダとスタートアップコード
- **出力**: CMakeターゲット `CMSIS5::Device::F4`
- **ソース**: STMicroelectronics/cmsis-device-f4
- **含まれるもの**:
  - デバイスヘッダ (stm32f4xx.h等)
  - スタートアップファイル
  - システム初期化コード

### STM32 HAL パッケージ

#### stm32-hal-f3xx
- **説明**: STM32F3シリーズ用HAL (Hardware Abstraction Layer) ドライバ
- **出力**: CMakeターゲット `STM32::HAL::F3xx`
- **ソース**: STMicroelectronics/stm32f3xx-hal-driver
- **含まれるもの**:
  - HALドライバ (GPIO, UART, SPI, I2C等)
  - リンカスクリプト (STM32F303K8TX_FLASH.ld)
- **依存**: cmsis5-device-f3

#### stm32-hal-f4xx
- **説明**: STM32F4シリーズ用HAL (Hardware Abstraction Layer) ドライバ
- **出力**: CMakeターゲット `STM32::HAL::F4xx`
- **ソース**: STMicroelectronics/stm32f4xx-hal-driver
- **含まれるもの**:
  - HALドライバ (GPIO, UART, SPI, I2C等)
  - リンカスクリプト (STM32F446RETX_FLASH.ld)
- **依存**: cmsis5-device-f4

### Mbed OS パッケージ

#### mbed-os
- **説明**: Mbed OS (MbedCE フォーク) のソースとCMake設定
- **出力**: 
  - `MbedCE-Toolchain.cmake`: ツールチェーン設定
  - `MbedCE.cmake`: プロジェクト設定
  - `Findmbed-ce.cmake`: パッケージ検索設定
- **ソース**: mbed-ce/mbed-os
- **Python環境**: mbed_tools, cysecuretools等を含む
- **用途**: Mbed OSプロジェクトのビルドに必要な基礎

#### static-mbed-os (関数)
- **説明**: Mbed OSを静的ライブラリとしてビルドする関数
- **パラメータ**:
  - pname: パッケージ名
  - mbedTarget: Mbedターゲット (例: "NUCLEO_F446RE")
- **出力**: 
  - 静的ライブラリ
  - CMakeターゲット `StaticMbedOS`
  - ツールチェーンファイル
- **CMakeフラグ**:
  - CMAKE_BUILD_TYPE: Develop
  - MBED_TARGET: 指定されたターゲット
  - TOOLCHAIN_MODE: LLVM
- **依存**: clang-arm-toolchain, cmake-libs, mbed-os

#### static-mbed-os-f446re
- **説明**: NUCLEO-F446RE用プリビルドMbed OS
- **ターゲット**: NUCLEO_F446RE
- **用途**: F446RE向け開発で即座に使用可能

#### static-mbed-os-f303k8
- **説明**: NUCLEO-F303K8用プリビルドMbed OS
- **ターゲット**: NUCLEO_F303K8
- **用途**: F303K8向け開発で即座に使用可能

### Python パッケージ (roboPythonPackages)

#### mbed_tools
- **説明**: Mbed OS開発用Pythonツール
- **機能**: ターゲット設定、ビルド設定生成
- **依存**: lief, packaging, click等

#### cysecuretools_6_0_0
- **説明**: Cypress/Infineonセキュリティツール
- **用途**: Mbed OSの一部機能で使用

その他: lief_0_14_1, packaging_21_3, click_8_0_4, cryptography_36_0_1

### エミュレータ・ツール

#### qemu-arm-xpack
- **説明**: QEMU ARM エミュレータ (xPack版)
- **用途**: ARMバイナリのホスト上でのエミュレーション実行
- **サポートデバイス**: STM32等のARMマイコンのエミュレーション

#### stlink (nixpkgs提供)
- **説明**: ST-Link プログラマ/デバッガツール
- **用途**: STM32への書き込みとデバッグ
- **STM32.enable時に自動追加**

## roboenv設定オプション詳細

### 基本設定

```nix
{
  name = "my-environment";        # 環境名
  extraBuildInputs = pkgs: [ ];   # 追加パッケージ
}
```

### C/C++ ツールチェーン (c_cpp)

```nix
{
  c_cpp.enable = true;
  c_cpp.toolchain = "gcc";  # または "clang"
}
```

**提供されるもの**:
- cmake, ninja
- gcc-arm-embedded (常に)
- clangツールチェーン (toolchain="clang"時)

**環境変数**:
- CMAKE_PREFIX_PATH: CMakeパッケージのパス
- CMAKE_MODULE_PATH: CMakeモジュールのパス
- CMAKE_TOOLCHAIN_FILE: Roboenv.cmakeのパス
- LIBCLANG_PATH: libclangのパス (clang時のみ)

### Rust ツールチェーン (rust)

```nix
{
  rust.enable = true;
}
```

**提供されるもの**:
- rust (stable, thumbv7em-none-eabi ターゲット付き)
- rust-analyzer, rustfmt, clippy
- rust-cbindgen
- pkg-config, udev

**環境変数**:
- RUST_SRC_PATH: Rustソースコードのパス

### STM32 サポート (STM32)

```nix
{
  STM32.enable = true;
  STM32.emulator = "qemu-arm-xpack";  # または null
}
```

**提供されるもの**:
- stlink (常に)
- qemu-arm-xpack (emulator指定時)

### フレームワーク (frameworks)

```nix
{
  frameworks = [
    {
      type = "StaticMbedOS";
      mbedTarget = "NUCLEO_F446RE";
    }
    {
      type = "STM32HAL";
      family = "f4";  # "f3" または "f4"
    }
  ];
}
```

**フレームワークタイプ**:
- **StaticMbedOS**: 静的ビルド済みMbed OS
  - mbedTarget必須
  - 対応ターゲット: Mbed OSがサポートする全ターゲット
  
- **StaticMbedCE**: (StaticMbedOSと同様、将来の拡張用)
  
- **STM32HAL**: STM32 HALドライバ
  - family必須 ("f3" | "f4")
  - CMSIS Device自動追加

### ライブラリ (libraries)

```nix
{
  libraries = with roboenv.roboPackages; [
    someLibrary
    anotherLibrary
  ];
}
```

**動作**:
- 各ライブラリのcmakeBuildInputsを再帰的に収集
- CMAKE_PREFIX_PATHに自動追加

### USBツール (tool.usb)

```nix
{
  tool.usb.enable = true;
}
```

**提供されるもの**:
- `list-devices` コマンド: USB デバイスの一覧表示

## CMake統合の詳細

### cmakeBuildInputs パターン

各パッケージは以下の形式で依存関係を宣言:

```nix
package // {
  cmakeBuildInputs = [ dep1 dep2 ];
}
```

### 依存関係の解決フロー

1. **収集**: `rlib.collectCMakePackages` が再帰的に依存を収集
2. **結合**: `rlib.cmakeLinkJoin` がトランポリンファイルを生成
3. **環境設定**: CMAKE_PREFIX_PATH / CMAKE_MODULE_PATHに設定

### トランポリンファイル

cmakeLinkJoinは各CMakeファイルに対してトランポリンを生成:

```cmake
# $out/lib/cmake/PackageName/PackageNameConfig.cmake
include(/nix/store/xxx-package/lib/cmake/PackageName/PackageNameConfig.cmake)
```

これにより、すべてのCMakeパッケージが単一のプレフィックスから参照可能。

### CMake使用例

```cmake
cmake_minimum_required(VERSION 3.19)

# Roboenv toolchainを使用
# CMAKE_TOOLCHAIN_FILE環境変数経由で設定済み
project(MyProject)

# find_packageでパッケージを検索
find_package(StaticMbedOS REQUIRED)
find_package(CMSIS5 REQUIRED)

add_executable(main main.cpp)
target_link_libraries(main
  StaticMbedOS
  CMSIS5::Core
)

# Mbed特有の設定適用
static_mbed_os_app_target(main)
```

## ビルドテスト

各パッケージには対応するビルドテストが存在:

- `tests/build-test`: StaticMbedOS
- `tests/build-test-cmsis5`: CMSIS5
- `tests/build-test-cmsis5-device-f3`: CMSIS5 Device F3
- `tests/build-test-cmsis5-device-f4`: CMSIS5 Device F4
- `tests/build-test-stm32-hal-f3xx`: STM32 HAL F3
- `tests/build-test-stm32-hal-f4xx`: STM32 HAL F4

すべてのテストは `rlib.buildCMakeProject` を使用して実際にビルドを実行し、
パッケージが正しく機能することを検証。

## 内部ライブラリ (rlib) API

### collectCMakePackages
```nix
collectCMakePackages :: Package -> [Package]
```
パッケージとその cmakeBuildInputs を再帰的に収集。

### buildCMakeProject
```nix
buildCMakeProject :: {
  pname, version, src,
  cmakeFlags, cmakeBuildInputs,
  ...
} -> Derivation
```
CMakeプロジェクトをビルドし、cmakeBuildInputs属性を付加。

### cmakeLinkJoin
```nix
cmakeLinkJoin :: {
  pname,
  packages :: [Package]
} -> Derivation
```
複数のCMakeパッケージを結合し、トランポリンファイルを生成。

### flatAttr
```nix
flatAttr :: AttrSet -> AttrSet
```
ネストした属性セットをフラット化。

### scopeToAttrRecursive
```nix
scopeToAttrRecursive :: Scope -> AttrSet
```
Nixpkgsスコープを通常の属性セットに変換。
