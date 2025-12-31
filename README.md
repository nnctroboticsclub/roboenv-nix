# roboenv-nix

Nix Flake による組み込みシステム開発環境です。STM32、Mbed OS、ARM Cortex-M 向けのツールチェーンとライブラリを提供します。

## 特徴

- **Nix Flake ネイティブ**: `packages` と `legacyPackages` でパッケージを提供
- **nixpkgs スタイル**: `import` で直接読み込み可能
- **Module System**: 型安全な設定で開発環境を構築
- **フラットな構造**: すべてのパッケージに直接アクセス可能

## 使い方

### 1. Flake として使用

```nix
{
  inputs.roboenv-nix.url = "github:nnctroboticsclub/roboenv-nix";

  outputs = { nixpkgs, roboenv-nix, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # すべてのパッケージにアクセス
      roboenv = roboenv-nix.legacyPackages.${system};
    in {
      devShells.${system}.default = roboenv.roboenv {
        name = "my-project";

        c_cpp.enable = true;
        c_cpp.toolchain = "gcc";

        STM32.enable = true;

        frameworks = [{
          type = "StaticMbedOS";
          mbedTarget = "NUCLEO_F446RE";
        }];

        libraries = with roboenv.roboPackages; [
          ikarashiCAN_mk2
          ikakoMDC
        ];
      };
    };
}
```

### 2. 個別パッケージのビルド

```bash
# 主要パッケージは packages からビルド可能
nix build github:nnctroboticsclub/roboenv-nix#cmake-libs
nix build github:nnctroboticsclub/roboenv-nix#cmsis5
nix build github:nnctroboticsclub/roboenv-nix#ikarashiCAN_mk2

# すべてのパッケージは legacyPackages からアクセス可能
nix build github:nnctroboticsclub/roboenv-nix#legacyPackages.x86_64-linux.mbed-os
```

### 3. nixpkgs スタイルで import

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

### 4. Overlay として使用（後方互換）

```nix
{
  nixpkgs.overlays = [
    roboenv-nix.overlays.default
  ];
}
```

## 提供パッケージ

### ツールチェーン
- `cmake-libs`: CMake 用のライブラリとツール
- `gcc-arm-toolchain`: GCC ARM ツールチェーン
- `clang-arm-toolchain`: Clang ARM ツールチェーン

### フレームワーク
- `cmsis5`: CMSIS v5 (Cortex Microcontroller Software Interface Standard)
- `cmsis5-device-f3`: STM32F3 デバイスサポート
- `cmsis5-device-f4`: STM32F4 デバイスサポート
- `stm32-hal-f3xx`: STM32F3 HAL
- `stm32-hal-f4xx`: STM32F4 HAL
- `static-mbed-os-f446re`: Mbed OS (NUCLEO-F446RE 用)
- `static-mbed-os-f303k8`: Mbed OS (NUCLEO-F303K8 用)
- `mbed-os`: Mbed OS 汎用

### ロボット制御ライブラリ
- `roboPackages.ikarashiCAN_mk2`: CAN 通信ライブラリ
- `roboPackages.ikakoMDC`: モータードライバー制御
- `roboPackages.ikako_rohm_md`: ROHM モータードライバー
- `roboPackages.MotorController`: モーターコントローラー

### ツール
- `qemu-arm-xpack`: ARM エミュレータ

## Module オプション

roboenv は Nixpkgs Module System を使って型安全に設定できます：

```nix
roboenv.roboenv {
  # プロジェクト名
  name = "my-project";

  # C/C++ ツールチェーン
  c_cpp.enable = true;
  c_cpp.toolchain = "gcc";  # or "clang"
  c_cpp.cache = "ccache";

  # Rust サポート
  rust.enable = true;
  rust.targets = [ "thumbv7em-none-eabi" ];

  # STM32 サポート
  STM32.enable = true;
  STM32.emulator = "qemu-arm-xpack";

  # フレームワーク
  frameworks = [
    {
      type = "StaticMbedOS";
      mbedTarget = "NUCLEO_F446RE";
    }
    {
      type = "STM32HAL";
      family = "f4";
    }
  ];

  # ライブラリ
  libraries = with roboenv.roboPackages; [
    ikarashiCAN_mk2
    ikakoMDC
  ];

  # 追加の buildInputs
  extraBuildInputs = pkgs: with pkgs; [
    # カスタムパッケージ
  ];
}
```

## ライセンス

各パッケージのライセンスについては、それぞれのディレクトリを参照してください。
