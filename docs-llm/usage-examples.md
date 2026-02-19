# roboenv-nix 使用例集

## 基本的な使用パターン

### 1. シンプルなSTM32プロジェクト (HAL使用)

```nix
# flake.nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.roboenv-nix.url = "github:nnctroboticsclub/roboenv-nix";

  outputs = { nixpkgs, roboenv-nix, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      roboenv = roboenv-nix.legacyPackages.${system};
    in {
      devShells.${system}.default = roboenv.roboenv {
        name = "stm32-hal-project";

        c_cpp.enable = true;
        c_cpp.toolchain = "gcc";

        STM32.enable = true;

        frameworks = [{
          type = "STM32HAL";
          family = "f4";
        }];
      };
    };
}
```

**使用方法**:
```bash
nix develop
cmake -S . -B build -G Ninja
cmake --build build
```

**CMakeLists.txt例**:
```cmake
cmake_minimum_required(VERSION 3.19)
project(STM32Project C ASM)

add_executable(firmware
  src/main.c
  src/stm32f4xx_hal_msp.c
)

target_link_libraries(firmware
  STM32::HAL::F4xx
)
```

---

### 2. Mbed OSプロジェクト

```nix
# flake.nix
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
        c_cpp.toolchain = "clang";  # Mbed OSはClang推奨

        STM32.enable = true;

        frameworks = [{
          type = "StaticMbedOS";
          mbedTarget = "NUCLEO_F446RE";
        }];
      };
    };
}
```

**CMakeLists.txt例**:
```cmake
cmake_minimum_required(VERSION 3.19)
project(MbedProject CXX C ASM)

add_executable(firmware
  src/main.cpp
)

target_link_libraries(firmware
  StaticMbedOS
)

# Mbed特有の設定を適用
static_mbed_os_app_target(firmware)
```

**main.cpp例**:
```cpp
#include "mbed.h"

DigitalOut led(LED1);

int main() {
    while (true) {
        led = !led;
        ThisThread::sleep_for(500ms);
    }
}
```

---

### 3. 複数ターゲット対応プロジェクト

```nix
# flake.nix
{
  inputs.roboenv-nix.url = "github:nnctroboticsclub/roboenv-nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { roboenv-nix, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      roboenv = roboenv-nix.legacyPackages.${system};
    in {
      devShells.${system}.default = roboenv.roboenv {
        name = "multi-target-project";

        c_cpp.enable = true;
        c_cpp.toolchain = "clang";

        STM32.enable = true;
        STM32.emulator = "qemu-arm-xpack";

        # 複数のターゲット用フレームワークを同時に利用可能
        frameworks = [
          {
            type = "StaticMbedOS";
            mbedTarget = "NUCLEO_F446RE";
          }
          {
            type = "StaticMbedOS";
            mbedTarget = "NUCLEO_F303K8";
          }
        ];
      };
    };
}
```

**ビルド時にターゲットを切り替え**:
```bash
# F446RE用ビルド
cmake -S . -B build-f446re -DTARGET=F446RE
cmake --build build-f446re

# F303K8用ビルド
cmake -S . -B build-f303k8 -DTARGET=F303K8
cmake --build build-f303k8
```

---

### 4. Rust + C/C++ ハイブリッドプロジェクト

```nix
# flake.nix
{
  inputs.roboenv-nix.url = "github:nnctroboticsclub/roboenv-nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { roboenv-nix, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      roboenv = roboenv-nix.legacyPackages.${system};
    in {
      devShells.${system}.default = roboenv.roboenv {
        name = "rust-embedded-project";

        c_cpp.enable = true;
        c_cpp.toolchain = "clang";

        rust.enable = true;  # Rustサポート有効化

        STM32.enable = true;

        frameworks = [{
          type = "StaticMbedOS";
          mbedTarget = "NUCLEO_F446RE";
        }];
      };
    };
}
```

**Cargo.toml例**:
```toml
[package]
name = "rust-embedded"
version = "0.1.0"
edition = "2021"

[dependencies]
cortex-m = "0.7"
cortex-m-rt = "0.7"

[profile.release]
opt-level = "z"
lto = true
```

**.cargo/config.toml**:
```toml
[build]
target = "thumbv7em-none-eabi"

[target.thumbv7em-none-eabi]
rustflags = ["-C", "link-arg=-Tlink.x"]
```

---

### 5. カスタムライブラリの追加

プロジェクト固有のライブラリをCMakeパッケージとして作成:

```nix
# flake.nix
{
  inputs.roboenv-nix.url = "github:nnctroboticsclub/roboenv-nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { roboenv-nix, nixpkgs, self, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      roboenv = roboenv-nix.legacyPackages.${system};

      # カスタムライブラリをビルド
      myLibrary = roboenv.rlib.buildCMakeProject {
        pname = "my-library";
        version = "1.0.0";
        src = ./lib/my-library;
        
        cmakeBuildInputs = [
          roboenv.cmsis5
        ];
      };

    in {
      devShells.${system}.default = roboenv.roboenv {
        name = "custom-lib-project";

        c_cpp.enable = true;
        c_cpp.toolchain = "gcc";

        STM32.enable = true;

        frameworks = [{
          type = "STM32HAL";
          family = "f4";
        }];

        # カスタムライブラリを追加
        libraries = [ myLibrary ];
      };
    };
}
```

---

### 6. デバッグ・開発ツール追加

```nix
# flake.nix
{
  inputs.roboenv-nix.url = "github:nnctroboticsclub/roboenv-nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { roboenv-nix, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      roboenv = roboenv-nix.legacyPackages.${system};
    in {
      devShells.${system}.default = roboenv.roboenv {
        name = "dev-tools-project";

        c_cpp.enable = true;
        c_cpp.toolchain = "clang";

        STM32.enable = true;
        STM32.emulator = "qemu-arm-xpack";

        tool.usb.enable = true;  # USBデバイスリスト表示

        frameworks = [{
          type = "StaticMbedOS";
          mbedTarget = "NUCLEO_F446RE";
        }];

        # 開発ツールを追加
        extraBuildInputs = pkgs: with pkgs; [
          gdb
          openocd
          minicom
          screen
          gcc-arm-embedded-12  # バージョン指定も可能
        ];
      };
    };
}
```

**使用可能なコマンド**:
```bash
# USBデバイス確認
list-devices

# OpenOCD起動
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg

# GDBデバッグ
arm-none-eabi-gdb build/firmware.elf

# シリアル通信
minicom -D /dev/ttyACM0
```

---

### 7. CI/CD用最小構成

```nix
# flake.nix
{
  inputs.roboenv-nix.url = "github:nnctroboticsclub/roboenv-nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { roboenv-nix, nixpkgs, self, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      roboenv = roboenv-nix.legacyPackages.${system};
    in {
      # 開発環境
      devShells.${system}.default = roboenv.roboenv {
        name = "firmware-dev";
        c_cpp.enable = true;
        c_cpp.toolchain = "clang";
        STM32.enable = true;
        frameworks = [{ type = "StaticMbedOS"; mbedTarget = "NUCLEO_F446RE"; }];
      };

      # ビルド成果物
      packages.${system} = {
        firmware = pkgs.stdenv.mkDerivation {
          name = "firmware";
          src = self;
          
          nativeBuildInputs = [
            pkgs.cmake
            pkgs.ninja
          ];
          
          buildInputs = [
            roboenv.clang-arm-toolchain
            roboenv.static-mbed-os-f446re
          ];
          
          buildPhase = ''
            cmake -S . -B build -G Ninja
            cmake --build build
          '';
          
          installPhase = ''
            mkdir -p $out/bin
            cp build/firmware.bin $out/bin/
            cp build/firmware.elf $out/bin/
          '';
        };
      };
    };
}
```

**GitHub Actions例**:
```yaml
name: Build Firmware
on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: cachix/install-nix-action@v20
      - uses: cachix/cachix-action@v12
        with:
          name: your-cache-name
      - run: nix build .#firmware
```

---

### 8. 既存のnixpkgsプロジェクトに統合

```nix
# flake.nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.roboenv-nix.url = "github:nnctroboticsclub/roboenv-nix";

  outputs = { nixpkgs, roboenv-nix, ... }:
    let
      system = "x86_64-linux";
      
      # roboenv-nixをoverlayとして使用
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ roboenv-nix.overlays.default ];
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # roboenv-nixのパッケージを直接使用
          cmsis5
          stm32-hal-f4xx
          gcc-arm-toolchain
          
          # 既存のnixpkgsパッケージと組み合わせ
          cmake
          ninja
          stlink
        ];
      };
    };
}
```

---

## トラブルシューティング

### ビルドエラー: "Cannot find toolchain file"

**原因**: CMAKE_TOOLCHAIN_FILE環境変数が設定されていない

**解決**:
```bash
# 環境変数を確認
echo $CMAKE_TOOLCHAIN_FILE

# roboenv内でビルドしているか確認
nix develop
```

### リンカエラー: "undefined reference to..."

**原因**: 必要なライブラリがリンクされていない

**解決**:
```cmake
# CMakeLists.txtで必要なライブラリを全てリンク
target_link_libraries(firmware
  StaticMbedOS      # または STM32::HAL::F4xx
  CMSIS5::Core      # 必要に応じて
)
```

### Mbed OS: "Target not found"

**原因**: mbedTargetのスペルミスまたは未サポートターゲット

**解決**:
```bash
# サポートされているターゲットを確認
nix develop
mbed-tools target list
```

### Nix: "error: attribute ... missing"

**原因**: パッケージ名のタイプミスまたはlegacyPackagesの参照忘れ

**解決**:
```nix
# 正しい参照方法
roboenv-nix.legacyPackages.${system}.package-name

# 利用可能なパッケージをリスト
nix eval .#legacyPackages.x86_64-linux --apply builtins.attrNames
```

---

## ベストプラクティス

### 1. Flake.lockを必ずコミット
```bash
git add flake.lock
git commit -m "Lock dependencies"
```

### 2. 開発環境の再現性確保
```bash
# 厳密な再現性チェック
nix flake check

# ビルドキャッシュの活用
cachix use roboenv-nix  # 公開されている場合
```

### 3. ディレクトリ構造の推奨
```
project/
├── flake.nix
├── flake.lock
├── CMakeLists.txt
├── src/
│   └── main.cpp
├── lib/
│   └── custom-library/
└── .gitignore
```

### 4. .gitignoreの推奨内容
```gitignore
build/
build-*/
result
result-*
.direnv/
```

### 5. direnv統合
```bash
# .envrc
use flake
```

```bash
direnv allow
# 自動的にnix developが実行される
```
