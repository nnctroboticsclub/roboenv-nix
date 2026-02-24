# Application テンプレート

Roboenv-nix を用いた、 F3Baremetal と StaticMbedOS のサンプルです。
StaticMbedOS は NUCLEO_F446RE 向けのものを利用しています

## direnv

このサンプルでは [direnv](https://github.com/nix-community/nix-direnv) を用いています。
direnv はシェルと連携し、特定のディレクトリ配下にカレントディレクトリがあるときに特定の環境変数を設定できるツールです。

## ビルド

このプロジェクトのディレクトリに移動し以下のコマンドを実行することでビルドできます。

`$` 以降の文字列を実行すればビルドできます。
`#` 以降の文字列はコメントです。

```shell
# Configure
# build ディレクトリはこのコマンドで作成される
$ cmake -S . -B build

# Build
# 実際にビルドするコマンド
# build ディレクトリがあれば Configure は行わなくても自動で Build 直前に Configure される
$ cmake --build build
```

## direnv を用いないビルド

flake.nix の提供する devShell 上で CMake を利用することでビルドできます。

```shell
# Nix DevShell に入る
$ nix develop
# このコマンド以降は DevShell 内での操作になる
# DevShell を抜けるときは exit を実行するだけで良い

$ cmake -S . -B build
```

## 書き込み

以下のコマンドで PC に接続されている ST-Link を経由してマイコンに書き込むことができます。

```shell
$ ninja -C build upload_<ターゲット名>
```

例えば、このプロジェクトで提供する `90-f3h-main` の書き込みは以下のようになります。
一般に `embedded_transform_target` に渡す文字列がそのまま `ターゲット名` に対応します。
```shell
$ ninja -C build upload_90-f3h-main
```

また、特定デバイスへの書き込みは以下のようなコマンドで行います。

```shell
$ FLASH_ARGS="--serial <ST-Link のシリアル番号>" ninja -C build upload_<ターゲット名>
```

ST-Link のシリアル番号は以下のコマンドで取得できます。
`flake.nix` の DevShell の定義で `tool.usb.enable = true;` が指定されていることが前提です。
```shell
$ list-devices
...
0483:374b (        0670FF373146363143202623) :: STM32 STLink
...
```
この出力がされた場合 `0670FF373146363143202623` がシリアル番号になります。
