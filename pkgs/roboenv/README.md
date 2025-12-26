# roboenv Shell Generator

roboenv 関数は、Nix シェル環境を生成するためのツールです。

## 使用方法

利用例を [example.nix](./example.nix) に示します。

## 実装

各プロパティ (e.g. `c_cpp.enable` excluding `extraBuildInputs`) に対応するファイルを `roboenv/modules/*.nix` に配置する
callPackage で読み込み、 `roboenv/default.nix` で合成する
プロパティーのパースは `roboenv/default.nix` で行う
