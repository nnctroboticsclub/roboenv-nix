# roboenv-nix 調査サマリー

## 調査完了日
2026年2月19日

## プロジェクト概要

**roboenv-nix**は、Nix Flakeベースの組み込みシステム開発環境パッケージ群。
STM32、ARM Cortex-M マイコン向けの統合開発環境を提供する先進的なプロジェクト。

### 核心的特徴

1. **Nixpkgs Module System統合**
   - 型安全な設定システム
   - 宣言的な環境構築
   - モジュール単位での機能管理

2. **独自のCMake統合メカニズム**
   - `cmakeBuildInputs`パターン
   - 再帰的依存関係収集
   - トランポリンファイルによる統合

3. **完全な再現性**
   - Flakeによる依存固定
   - ビルドキャッシュ対応
   - CI/CD統合容易

## 主要コンポーネント

### 1. パッケージ階層

```
legacyPackages (Scope)
├── ツールチェーン
│   ├── cmake-libs
│   ├── gcc-arm-toolchain
│   └── clang-arm-toolchain
├── CMSIS系
│   ├── cmsis5
│   ├── cmsis5-device-f3
│   └── cmsis5-device-f4
├── STM32 HAL
│   ├── stm32-hal-f3xx
│   └── stm32-hal-f4xx
├── Mbed OS
│   ├── mbed-os
│   ├── static-mbed-os (関数)
│   ├── static-mbed-os-f446re
│   └── static-mbed-os-f303k8
└── ツール
    ├── qemu-arm-xpack
    └── roboPythonPackages (Scope)
```

### 2. roboenv Module System

モジュール構成:
- **base.nix**: 基本オプション、CMake統合の中核
- **c_cpp.nix**: C/C++ツールチェーン (gcc/clang切替)
- **rust.nix**: Rustサポート (thumbv7em-none-eabi)
- **stm32.nix**: STM32開発サポート (stlink, qemu)
- **frameworks.nix**: フレームワーク管理 (Mbed, HAL)
- **libraries.nix**: ライブラリ管理
- **usb/**: USBツールサポート

### 3. 内部ライブラリ (rlib)

- **collectCMakePackages**: 再帰的依存収集
- **buildCMakeProject**: CMakeビルドヘルパー
- **cmakeLinkJoin**: パッケージ統合とトランポリン生成
- **flatAttr/scopeToAttrRecursive**: ユーティリティ

## 技術的洞察

### CMake統合の巧妙さ

roboenv-nixの最大の特徴は、Nixパッケージ管理とCMake依存解決を
完全に統合している点。

1. 各パッケージが `cmakeBuildInputs` 属性で依存を宣言
2. `collectCMakePackages` が依存グラフを再帰的に走査
3. `cmakeLinkJoin` が全CMakeファイルへの `include()` を生成
4. 単一のプレフィックスに統合され、CMAKE_PREFIX_PATHに設定

これにより、開発者は:
- Nix側: `libraries = [ pkg1 pkg2 ];`
- CMake側: `find_package(pkg1)` `find_package(pkg2)`

と書くだけで、複雑な依存関係が自動解決される。

### Module Systemの活用

Nixpkgs Module Systemを採用することで:
- オプションの型チェック
- デフォルト値の設定
- 条件分岐 (`lib.mkIf`)
- モジュール間の依存関係

が実現され、単なるシェル環境以上の構造化された設定が可能。

### 静的Mbed OSのアプローチ

Mbed OSを事前に静的ライブラリとしてビルドし、それを配布する
アプローチは独特。これにより:
- ビルド時間の大幅短縮
- キャッシュ効率の向上
- 複数プロジェクトでの共有

が実現されている。

## 使用パターン分析

### 推奨パターン: Flake統合

```nix
roboenv-nix.legacyPackages.${system}.roboenv {
  # 宣言的設定
}
```

このパターンが推奨される理由:
- 型安全
- すべての機能にアクセス
- Module Systemの恩恵
- 将来の拡張に対応

### 柔軟性: 3つの追加パターン

1. **個別ビルド**: `nix build .#legacyPackages...`
2. **nixpkgs import**: `import ./. { inherit pkgs; }`
3. **Overlay**: 後方互換性

## プロジェクトの成熟度

### 強み

- ✅ 明確なアーキテクチャ
- ✅ 型安全な設定
- ✅ 包括的なパッケージカバレッジ
- ✅ テストの存在
- ✅ 実プロジェクトでの使用実績（NHK2025A等）

### 改善の余地

- ⚠️ packagesでの公開が限定的（現在testのみ）
- ⚠️ ドキュメントが少なかった（→本調査で追加）
- ⚠️ roboPackages参照が古いREADMEに残存
- ⚠️ STM32F1, F7等の他ファミリーは未サポート

## ユースケース

### 想定される主要ユースケース

1. **ロボコンプロジェクト**
   - 複数マイコンの統合開発
   - チーム開発での環境統一
   - CI/CD統合

2. **教育機関**
   - 再現可能な実習環境
   - 学生間の環境差異の排除

3. **プロトタイピング**
   - 迅速な環境構築
   - 複数ターゲットでの評価

4. **長期プロジェクト**
   - 依存関係の固定
   - 将来の再ビルド保証

## 設計哲学の分析

### 1. 宣言的 > 手続き的

設定は「何をするか」ではなく「何が欲しいか」を宣言:
```nix
STM32.enable = true;  # ← 欲しい機能
# vs
# buildInputs = [ stlink ... ];  # ← 手続き的
```

### 2. 構成可能性

小さなモジュールを組み合わせて複雑な環境を構築:
```nix
c_cpp + rust + STM32 + Mbed OS → 統合環境
```

### 3. 型安全性

Module Systemによりコンパイル時（評価時）にエラー検出:
```nix
STM32.emulator = "invalid";  # ← エラー: enumに含まれない
```

### 4. キャッシュ最適化

- パッケージの細分化
- 静的ライブラリの事前ビルド
- Cachix統合を意識した設計

## 技術的課題と解決

### 課題1: Mbed OSの複雑性

**問題**: Mbed OSはビルドが遅く、ターゲット依存

**解決**: 
- 静的ライブラリとして事前ビルド
- ターゲット別パッケージ
- Pythonツール統合

### 課題2: CMakeとNixの統合

**問題**: CMakeの依存解決とNixの依存管理は別物

**解決**:
- cmakeBuildInputsパターン
- トランポリンファイル
- CMAKE_PREFIX_PATHでの統合

### 課題3: ツールチェーンの切り替え

**問題**: GCCとClangで異なる設定が必要

**解決**:
- 統一されたインターフェース (c_cpp.toolchain)
- Module Systemでの条件分岐
- 各ツールチェーンが独自のCMakeファイルを提供

## 今後の発展可能性

### 短期的拡張

1. **追加STM32ファミリー**: F1, F7, H7等
2. **他社マイコン**: ESP32, RP2040等
3. **追加フレームワーク**: Zephyr, FreeRTOS等

### 中期的拡張

1. **ライブラリエコシステム**: 共有ライブラリリポジトリ
2. **デバッガ統合**: GDB, OpenOCDの自動設定
3. **シミュレーション**: QEMU統合の強化

### 長期的ビジョン

1. **クロスプラットフォーム**: macOS, Windows (WSL2) 対応
2. **クラウド開発**: Dev Containersとの統合
3. **AI支援**: 開発環境の自動推奨

## 結論

roboenv-nixは、Nixの強力な機能を活用した、
成熟度の高い組み込み開発環境パッケージ群。

**特に優れている点**:
- 型安全な設定システム
- CMakeとの深い統合
- 再現可能性の保証

**適用が推奨されるケース**:
- 複数人での開発
- 長期プロジェクト
- CI/CD統合が必要な場合

**学ぶべき設計パターン**:
- Module Systemの実践的活用
- cmakeBuildInputsパターン
- スコープベースのパッケージ管理

このプロジェクトは、Nixによる開発環境管理の
ベストプラクティスを体現している。

---

## 作成ドキュメント一覧

本調査で作成されたドキュメント:

1. **llm/investigation-notes.md**
   - 詳細なアーキテクチャ分析
   - 設計哲学
   - 内部実装の解説

2. **llm/package-details.md**
   - 全パッケージのカタログ
   - API詳細
   - 設定オプション完全ガイド

3. **llm/usage-examples.md**
   - 8つの実践的使用例
   - トラブルシューティング
   - ベストプラクティス

4. **README.md** (更新)
   - 包括的な概要
   - クイックスタート
   - アーキテクチャ説明
   - コントリビュートガイド

これらのドキュメントにより、roboenv-nixの理解と利用が
大幅に容易になることを期待する。
