{
  # 開発環境
  inputs.roboenv.url = "git+ssh://git@github.com/nnctroboticsclub/roboenv-nix";

  # ライブラリ群
  inputs.robopkgs.url = "git+ssh://git@github.com/nnctroboticsclub/robopkgs-nix";

  outputs =
    {
      robopkgs,
      roboenv,
      ...
    }:
    let
      system = "x86_64-linux";
      # roboenv の提供するパッケージ群
      roboPkgs = roboenv.legacyPackages.${system};
      # robopkgs の提供するパッケージ群
      roboLibs = robopkgs.legacyPackages.${system};
    in
    {
      # メインの開発環境 (`default` が識別子)
      devShells.x86_64-linux.default = roboPkgs.roboenv {
        # 開発環境の名前
        name = "Robotics Project";

        # 以下よく使う機能の定義
        # パラメータの詳細: https://github.com/nnctroboticsclub/roboenv-nix/tree/main/pkgs/roboenv

        STM32.enable = true;
        c_cpp.enable = true;
        c_cpp.toolchain = "clang";
        tool.usb.enable = true;

        frameworks = [
          {
            type = "StaticMbedOS";
            mbedTarget = "NUCLEO_F446RE";
          }
        ];

        cmakeInputs = [
          roboPkgs.cmake-libs
          roboLibs.nano
        ];
      };
    };
}
