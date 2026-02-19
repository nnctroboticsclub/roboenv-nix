# roboenv-nix 調査メモ

## プロジェクト概要

**roboenv-nix** は Nix Flake ベースの組み込みシステム開発環境パッケージ群。
STM32、ARM Cortex-M マイコン向けの開発ツールチェーンとフレームワークを提供する。

### 主な特徴
- Nix Flake ネイティブ設計
- Nixpkgs Module System を使った型安全な設定
- フラットなパッケージ構造
- CMake統合が中心的な役割

## アーキテクチャ

### 1. エントリポイント構造

- **flake.nix**: メインのFlakeエントリポイント
  - 外部依存: nixpkgs, rust-overlay, 各種STM32/CMSIS/Mbedソース
  - `legacyPackages.${system}`: 全パッケージを公開
  - `packages`: 一部の主要パッケージ（現在はtestのみ）
  - `devShells.default`: サンプル開発シェル
  - `overlays.default`: 後方互換用

- **default.nix**: nixpkgsスタイルのimport可能なエントリ
  ```nix
  import /path/to/roboenv-nix { inherit pkgs; }
  ```

- **shell.nix**: Cachixフルキャッシュ用の全機能有効化シェル

### 2. パッケージ構造 (pkgs/)

**pkgs/default.nix**: `lib.makeScope` でスコープを作成
  - すべてのパッケージを単一のスコープで管理
  - 各パッケージは `self.callPackage` で呼び出される
  - パッケージ間の依存関係を自動解決

#### 主要パッケージグループ

##### ツールチェーン系
- **gcc-arm-toolchain**: GCC ARM Embedded用のCMakeツールチェーンファイル生成
- **clang-arm-toolchain**: Clang ARM用のCMakeツールチェーンファイル生成
- **clang-toolchain**: 通常のClang（ホスト向け）
- **cmake-libs**: CMake用の共通ライブラリとツール

##### フレームワーク系
- **cmsis5**: CMSIS v5 (ARM標準ソフトウェアインターフェース)
- **CMSIS5DevicePackages**: デバイス固有のCMSISパッケージグループ
  - cmsis5-device-f3: STM32F3用
  - cmsis5-device-f4: STM32F4用

- **STM32HALPackages**: STM32 HALドライバパッケージグループ
  - stm32-hal-f3xx: STM32F3用HAL
  - stm32-hal-f4xx: STM32F4用HAL

- **mbed-os**: Mbed OS (MbedCE フォーク) のソースパッケージ
- **StaticMbedOSPackages**: 静的リンク済みMbed OSパッケージグループ
  - static-mbed-os: 汎用ビルド関数
  - static-mbed-os-f446re: NUCLEO-F446RE用プリビルド
  - static-mbed-os-f303k8: NUCLEO-F303K8用プリビルド

##### Python関連
- **roboPythonPackages**: Mbed ツール用Pythonパッケージスコープ
  - lief_0_14_1, packaging_21_3, click_8_0_4, cryptography_36_0_1
  - cysecuretools_6_0_0, mbed_tools

##### エミュレータ・ツール
- **qemu-arm-xpack**: QEMU ARM エミュレータ

##### roboenv本体
- **roboenv**: Module System ベースの開発環境構築関数

### 3. roboenv Module System

**pkgs/roboenv/default.nix**: エントリポイント
- `lib.evalModules` でNixpkgs Module Systemを使用
- ユーザー設定を型安全に評価
- 最終的に `pkgs.mkShell` を返す

#### モジュール構造 (pkgs/roboenv/modules/)

1. **base.nix**: 基本オプション定義
   - name: 環境名
   - buildInputs: パッケージリスト
   - cmakeInputs: CMakeパッケージリスト（自動的にCMAKE_PREFIX_PATHに追加）
   - shellHook: シェル初期化スクリプト
   - extraBuildInputs: 追加パッケージ関数
   - env: 環境変数
   - debug.cmakePackages: デバッグ用CMakeパッケージ情報

2. **c_cpp.nix**: C/C++ツールチェーン
   - enable: 有効化フラグ
   - toolchain: "gcc" | "clang"
   - 提供: cmake, ninja, gcc-arm-embedded (またはclang一式)
   - CMAKE_TOOLCHAIN_FILE環境変数の設定
   - LIBCLANG_PATH環境変数の設定（clangの場合）

3. **rust.nix**: Rustツールチェーン
   - enable: 有効化フラグ
   - 提供: rust (thumbv7em-none-eabi), rust-analyzer, rustfmt, clippy, cbindgen
   - RUST_SRC_PATH環境変数の設定

4. **stm32.nix**: STM32開発サポート
   - enable: 有効化フラグ
   - emulator: "qemu-arm-xpack" | null
   - 提供: stlink, (オプション) qemu

5. **frameworks.nix**: フレームワーク管理
   - frameworks: リスト型オプション
   - 各フレームワーク:
     - type: "StaticMbedOS" | "StaticMbedCE" | "STM32HAL"
     - mbedTarget: Mbedターゲット名（Mbed系の場合）
     - family: "f3" | "f4" (STM32HALの場合)
   - 自動的にcmakeInputsに追加

6. **libraries.nix**: ライブラリ管理
   - libraries: ライブラリパッケージリスト
   - 自動的にcmakeInputsに追加

7. **usb/ (default.nix)**: USBツールサポート
   - tool.usb.enable: 有効化フラグ
   - list-devices コマンドをPATHに追加

### 4. 内部ライブラリ (pkgs/lib/)

**rlib**: 再利用可能なヘルパー関数群

- **collectCMakePackages**: パッケージから `cmakeBuildInputs` 属性を再帰的に収集
- **buildCMakeProject**: CMakeプロジェクトのビルドヘルパー
- **cmakeLinkJoin**: CMakeパッケージを結合してCMAKE_PREFIX_PATH用ディレクトリを作成
- **flatAttr**: 属性セットをフラット化
- **scopeToAttrRecursive**: スコープを通常の属性セットに変換

## CMake統合の仕組み

### cmakeBuildInputs パターン

各パッケージは `cmakeBuildInputs` 属性を持つことができる：
```nix
package // {
  cmakeBuildInputs = [ dep1 dep2 ... ];
}
```

これにより：
1. パッケージの依存関係を明示
2. `rlib.collectCMakePackages` で再帰的に収集
3. `rlib.cmakeLinkJoin` で結合
4. CMAKE_PREFIX_PATH / CMAKE_MODULE_PATH に設定

### ツールチェーンファイル

- gcc-arm-toolchain: `GccArmToolchain.cmake` を生成
  - CMAKE_C_COMPILER, CMAKE_CXX_COMPILER等を設定
  - USING_TOOLCHAIN="GNU"を定義

- clang-arm-toolchain: `ClangArmToolchain.cmake` を生成
  - Clang用のクロスコンパイル設定
  - USING_TOOLCHAIN="LLVM"を定義

- c_cpp.nix: `Roboenv.cmake` をCMAKE_TOOLCHAIN_FILEとして設定
  - ユーザー側でCMake時にこれを指定

## テスト構造 (tests/)

- build-test: static-mbed-osのビルドテスト
- build-test-cmsis5-device-f3/f4: CMSISデバイスのビルドテスト
- build-test-cmsis5: CMSIS5のビルドテスト
- build-test-stm32-hal-f3xx/f4xx: STM32 HALのビルドテスト

各テストは `rlib.buildCMakeProject` を使用して実際にビルドを実行。

## 外部依存関係

### Flake Inputs

- **nixpkgs**: 25.11リリース
- **rust-overlay**: Rustツールチェーン
- **cmsis5**: ARM CMSIS v5 ソース
- **cmsis-device-f3/f4**: STM32F3/F4 CMSISデバイスヘッダ
- **mbed-ce**: Mbed OS Community Edition (フォーク)
- **stm32f3xx/f4xx-hal-driver**: STM32 HALドライバソース

## ________OLD ディレクトリ

古いDocker/Dockerfile ベースの実装が保管されている。
現在は使用されていない。

## 使用パターン

### パターン1: Flakeとして使用（推奨）
```nix
{
  inputs.roboenv-nix.url = "github:nnctroboticsclub/roboenv-nix";
  outputs = { roboenv-nix, ... }: {
    devShells.default = roboenv-nix.legacyPackages.x86_64-linux.roboenv {
      # 設定
    };
  };
}
```

### パターン2: 個別パッケージビルド
```bash
nix build github:nnctroboticsclub/roboenv-nix#legacyPackages.x86_64-linux.cmsis5
```

### パターン3: nixpkgsスタイル
```nix
let roboenv = import /path/to/roboenv-nix { inherit pkgs; };
in { buildInputs = [ roboenv.cmsis5 ]; }
```

### パターン4: Overlay（後方互換）
```nix
nixpkgs.overlays = [ roboenv-nix.overlays.default ];
```

## 設計哲学

1. **型安全性**: Module Systemによる設定の型チェック
2. **宣言的設定**: enableフラグと設定オプションで環境を宣言
3. **再現性**: Nix Flakeによる完全な依存関係固定
4. **CMake中心**: 組み込み開発でよく使われるCMakeとの深い統合
5. **フラット構造**: legacyPackagesですべてのパッケージに直接アクセス可能
6. **キャッシュ最適化**: Cachix用に最適化されたビルド構造
