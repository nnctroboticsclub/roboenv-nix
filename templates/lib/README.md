# Library テンプレート

Roboenv-nix を用いた、ライブラリ開発環境のテンプレートです。

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

## インストールの検証

システムに書き込む前や GitHub に Push する前に、どのような形でインストールが行われるかを検証するには、以下のコマンドを実行します。
なお、 Configure が行われており build フォルダが生成されていることが条件です。

```shell
$ cmake --install build --prefix build/install
```

このコマンドを実行することで、 build/install にインストールが行われます。
