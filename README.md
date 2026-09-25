# roboenv-nix

Nix Flake による STM32 向け組み込みシステム開発環境です
再現可能な開発環境を宣言的に記述できます。

## クイックスタート

以下のコマンドを実行することで Application プロジェクトが展開されます。
通常の実行ファイルのビルドでは Application プロジェクトを利用すればよいです。

SSH 接続を用いて GitHub にアクセスでき、 git コマンドが利用できることが条件です。

```shell
$ nix flake init -t github:nnctroboticsclub/roboenv-nix.git#application
(snip)
```

ライブラリを作成する環境は以下のコマンドで展開できます。

```shell
$ nix flake init -t github:nnctroboticsclub/roboenv-nix.git#library
(snip)
```

## 関連リンク

- [ARM CMSIS](https://github.com/ARM-software/CMSIS_5)
- [STMicroelectronics CMSIS Device](https://github.com/STMicroelectronics)
- [Mbed OS Community Edition](https://github.com/mbed-ce/mbed-os)
- [Nix](https://nixos.org/)
