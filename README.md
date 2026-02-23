# roboenv-nix

Nix Flake による STM32 向け組み込みシステム開発環境です
再現可能な開発環境を宣言的に記述できます。

## クイックスタート

以下のコマンドを実行することで Application プロジェクトが展開されます。
通常の実行ファイルのビルドでは Application プロジェクトを利用すればよいです。

SSH 接続を用いて GitHub にアクセスできることが前提です。

```shell
$ nix flake init -t git+ssh://git@github.com/nnctroboticsclub/roboenv-nix.git#application
```

## 関連リンク

- [ARM CMSIS](https://github.com/ARM-software/CMSIS_5)
- [STMicroelectronics CMSIS Device](https://github.com/STMicroelectronics)
- [Mbed OS Community Edition](https://github.com/mbed-ce/mbed-os)
- [Nix](https://nixos.org/)
