# roboenv-nix

**Nix Flakeによる組み込みシステム開発環境**

STM32、ARM Cortex-Mマイコン向けの包括的な開発ツールチェーンとフレームワークを提供します。
Nixpkgs Module Systemによる型安全な設定で、再現可能な開発環境を簡単に構築できます。

## 特徴

- 🔧 **完全な型安全性**: Nixpkgs Module Systemによる設定の検証
- 📦 **豊富なパッケージ**: CMSIS、STM32 HAL、Mbed OS等を統合
- 🎯 **宣言的な設定**: `enable`フラグで必要な機能を有効化
- 🔗 **CMake統合**: 自動的な依存関係解決とCMAKE_PREFIX_PATH設定
- ♻️ **完全な再現性**: Nix Flakeによる依存関係の完全な固定
- 🚀 **柔軟な使用法**: Flake、nixpkgs import、overlay として使用可能

## クイックスタート

### 1. Mbed OSプロジェクト

```nix
{
  inputs.roboenv-nix.url = "github:nnctroboticsclub/roboenv-nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { roboenv-nix, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      roboenv = roboenv-nix.legacyPackages.${system};
    in {
      devShells.${system}.default = roboenv.roboenv {
        name = "mbed-project";

        c_cpp.enable = true;
        c_cpp.toolchain = "clang";

        STM32.enable = true;

        frameworks = [{
          type = "StaticMbedOS";
          mbedTarget = "NUCLEO_F446RE";
        }];
      };
    };
}
```

```bash
nix develop
cmake -S . -B build -G Ninja
cmake --build build
```

### 2. STM32 HALプロジェクト

```nix
frameworks = [{
  type = "STM32HAL";
  family = "f4";  # f3 または f4
}];
```

### 3. 複数ターゲット対応

```nix
frameworks = [
  { type = "StaticMbedOS"; mbedTarget = "NUCLEO_F446RE"; }
  { type = "StaticMbedOS"; mbedTarget = "NUCLEO_F303K8"; }
  { type = "STM32HAL"; family = "f4"; }
];
```

## 主要な設定オプション

### C/C++ ツールチェーン

```nix
c_cpp.enable = true;
c_cpp.toolchain = "gcc";  # または "clang"
```

**提供**: cmake, ninja, gcc-arm-embedded/clang, CMake統合

### Rust サポート

```nix
rust.enable = true;
```

**提供**: rust (thumbv7em-none-eabi), rust-analyzer, clippy, cbindgen

### STM32 開発

```nix
STM32.enable = true;
STM32.emulator = "qemu-arm-xpack";  # オプション
```

**提供**: stlink, qemu (オプション)

### USB ツール

```nix
tool.usb.enable = true;
```

**提供**: `list-devices` コマンド

### カスタムツール追加

```nix
extraBuildInputs = pkgs: with pkgs; [
  gdb
  openocd
  minicom
];
```

## 提供パッケージ

### ツールチェーン

| パッケージ | 説明 |
|---------|------|
| `cmake-libs` | CMake用共通ライブラリ |
| `gcc-arm-toolchain` | GCC ARM Embedded用CMakeツールチェーン |
| `clang-arm-toolchain` | Clang ARM用CMakeツールチェーン |

### CMSIS & STM32

| パッケージ | 説明 |
|---------|------|
| `cmsis5` | CMSIS v5 コアライブラリ |
| `cmsis5-device-f3` | STM32F3用CMSISデバイスヘッダ |
| `cmsis5-device-f4` | STM32F4用CMSISデバイスヘッダ |
| `stm32-hal-f3xx` | STM32F3 HALドライバ |
| `stm32-hal-f4xx` | STM32F4 HALドライバ |

### Mbed OS

| パッケージ | 説明 |
|---------|------|
| `mbed-os` | Mbed OS (MbedCE) ソースとCMake設定 |
| `static-mbed-os` | ターゲット指定可能なビルド関数 |
| `static-mbed-os-f446re` | NUCLEO-F446RE用プリビルド |
| `static-mbed-os-f303k8` | NUCLEO-F303K8用プリビルド |

### ツール

| パッケージ | 説明 |
|---------|------|
| `qemu-arm-xpack` | QEMU ARMエミュレータ |
| `mbed_tools` | Mbed開発ツール (Python) |

## 使用方法

### パターン1: Flake として使用（推奨）

```nix
{
  inputs.roboenv-nix.url = "github:nnctroboticsclub/roboenv-nix";

  outputs = { roboenv-nix, ... }:
    let
      roboenv = roboenv-nix.legacyPackages.x86_64-linux;
    in {
      devShells.x86_64-linux.default = roboenv.roboenv {
        # 設定
      };
    };
}
```

### パターン2: 個別パッケージビルド

```bash
# legacyPackages経由でアクセス
nix build github:nnctroboticsclub/roboenv-nix#legacyPackages.x86_64-linux.cmsis5
nix build github:nnctroboticsclub/roboenv-nix#legacyPackages.x86_64-linux.stm32-hal-f4xx
```

### パターン3: nixpkgs スタイル

```nix
let
  roboenv = import /path/to/roboenv-nix { inherit pkgs; };
in {
  buildInputs = [
    roboenv.cmake-libs
    roboenv.cmsis5
  ];
}
```

### パターン4: Overlay（後方互換）

```nix
{
  nixpkgs.overlays = [ roboenv-nix.overlays.default ];
}
```

## CMake統合

roboenv-nixは自動的にCMake環境を設定します：

```cmake
cmake_minimum_required(VERSION 3.19)
project(MyProject)

# パッケージは自動的に検索可能
find_package(StaticMbedOS REQUIRED)
find_package(CMSIS5 REQUIRED)

add_executable(firmware main.cpp)
target_link_libraries(firmware
  StaticMbedOS
  CMSIS5::Core
)

# Mbed特有の設定
static_mbed_os_app_target(firmware)
```

**自動設定される環境変数**:
- `CMAKE_PREFIX_PATH`: すべてのCMakeパッケージのパス
- `CMAKE_MODULE_PATH`: CMakeモジュールのパス
- `CMAKE_TOOLCHAIN_FILE`: ツールチェーン設定ファイル
- `LIBCLANG_PATH`: libclangのパス（Clang使用時）
- `RUST_SRC_PATH`: Rustソースのパス（Rust有効時）

## アーキテクチャ

### CMake統合の仕組み

roboenv-nixは独自の`cmakeBuildInputs`パターンで依存関係を管理します：

1. **パッケージ宣言**: 各パッケージは`cmakeBuildInputs`属性で依存を宣言
   ```nix
   package // { cmakeBuildInputs = [ dep1 dep2 ]; }
   ```

2. **再帰的収集**: `rlib.collectCMakePackages`で依存関係を再帰的に収集

3. **トランポリン生成**: `rlib.cmakeLinkJoin`がすべてのCMakeファイルへの
   includeを生成し、単一のプレフィックスに統合

4. **環境設定**: CMAKE_PREFIX_PATHとCMAKE_MODULE_PATHに自動設定

これにより、複雑な依存関係でも自動的に解決され、CMakeで`find_package`するだけで利用可能になります。

### Module System

roboenv関数はNixpkgs Module Systemを使用して設定を評価します：

- **型安全**: すべてのオプションは型定義されており、設定ミスを防止
- **モジュール化**: 各機能（c_cpp、rust、STM32等）が独立したモジュール
- **合成可能**: 複数のモジュールを組み合わせて環境を構築

詳細は[pkgs/roboenv/modules/](pkgs/roboenv/modules/)を参照してください。

## ディレクトリ構造

```
roboenv-nix/
├── flake.nix              # Flakeエントリポイント
├── default.nix            # nixpkgs importエントリポイント
├── shell.nix              # サンプル開発シェル
├── pkgs/                  # パッケージ定義
│   ├── default.nix        # パッケージスコープ定義
│   ├── lib/               # 内部ライブラリ (rlib)
│   ├── roboenv/           # roboenv本体とModule定義
│   ├── cmake-libs/        # CMake共通ライブラリ
│   ├── gcc-arm-toolchain/ # GCCツールチェーン
│   ├── clang-arm-toolchain/ # Clangツールチェーン
│   ├── cmsis5/            # CMSIS v5
│   ├── cmsis5-device/     # CMSISデバイスヘッダ
│   ├── stm32-hal/         # STM32 HAL
│   ├── mbed-os/           # Mbed OSソース
│   ├── static-mbed-os/    # 静的ビルドMbed OS
│   ├── qemu-arm-xpack/    # QEMUエミュレータ
│   └── roboPythonPackages/ # Pythonパッケージ
└── tests/                 # ビルドテスト
```

## 開発ガイド

### カスタムライブラリの作成

roboenv-nixのCMake統合を利用するライブラリを作成：

```nix
myLib = roboenv.rlib.buildCMakeProject {
  pname = "my-library";
  version = "1.0.0";
  src = ./my-lib;

  cmakeBuildInputs = [
    roboenv.cmsis5
  ];
};
```

### 新しいフレームワークの追加

1. `pkgs/`配下にパッケージディレクトリを作成
2. `pkgs/default.nix`でパッケージを公開
3. `pkgs/roboenv/modules/frameworks.nix`にフレームワークタイプを追加

### テストの追加

`tests/`配下に新しいテストを追加：

```nix
test-my-package = rlib.buildCMakeProject {
  pname = "test-my-package";
  src = ./test-src;
  cmakeBuildInputs = [ myPackage ];
};
```

## トラブルシューティング

### ビルドエラー

**"Cannot find toolchain file"**
- roboenv環境内でビルドしているか確認: `nix develop`
- CMAKE_TOOLCHAIN_FILE環境変数を確認: `echo $CMAKE_TOOLCHAIN_FILE`

**リンカエラー: "undefined reference"**
- CMakeLists.txtで必要なライブラリをすべてリンク
- 特にMbed OSの場合は`static_mbed_os_app_target()`の呼び出しを確認

**"Target not found" (Mbed OS)**
- mbedTargetのスペル確認
- サポートターゲットを確認: `mbed-tools target list`

### Nix関連

**"attribute ... missing"**
- パッケージは`legacyPackages`経由でアクセス
- 利用可能なパッケージ: `nix eval .#legacyPackages.x86_64-linux --apply builtins.attrNames`

**キャッシュヒットしない**
- Flake.lockをコミット
- Cachixの設定確認（公開されている場合）

## コントリビュート

Issue、Pull Requestを歓迎します。

### 開発環境

```bash
git clone https://github.com/nnctroboticsclub/roboenv-nix
cd roboenv-nix
nix develop
```

### テストの実行

```bash
nix build .#legacyPackages.x86_64-linux --all
nix flake check
```

## ライセンス

roboenv-nix自体のコード: MIT License

## 関連リンク

- [ARM CMSIS](https://github.com/ARM-software/CMSIS_5)
- [STMicroelectronics CMSIS Device](https://github.com/STMicroelectronics)
- [Mbed OS Community Edition](https://github.com/mbed-ce/mbed-os)
- [Nix](https://nixos.org/)

## 詳細ドキュメント

プロジェクトには以下の詳細ドキュメントが含まれています：

- [docs-llm/investigation-notes.md](docs-llm/investigation-notes.md): 詳細なアーキテクチャと設計哲学
- [docs-llm/package-details.md](docs-llm/package-details.md): 全パッケージの仕様とAPI
- [docs-llm/usage-examples.md](docs-llm/usage-examples.md): 実践的な使用例とベストプラクティス
- [pkgs/roboenv/README.md](pkgs/roboenv/README.md): roboenv本体の実装詳細
- [pkgs/static-mbed-os/README.md](pkgs/static-mbed-os/README.md): Mbed OS統合の詳細

### ツール
- `qemu-arm-xpack`: ARM エミュレータ

