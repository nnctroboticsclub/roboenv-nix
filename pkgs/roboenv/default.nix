{
  lib,
  pkgs,
  rlib,
  roboenvScope,
  ...
}:

config:

let
  # Nixpkgs Module System を使用して評価
  evaluated = lib.evalModules {
    modules = [
      ./modules/base.nix
      ./modules/c_cpp.nix
      ./modules/rust.nix
      ./modules/stm32.nix
      ./modules/frameworks.nix
      ./modules/libraries.nix
      # ユーザー設定
      { _module.args = { inherit pkgs rlib roboenvScope; }; }
      config
    ];
  };

  cfg = evaluated.config;

  # extraBuildInputs を適用
  allBuildInputs = cfg.buildInputs ++ (cfg.extraBuildInputs pkgs);

in
pkgs.mkShell (
  {
    name = cfg.name;
    buildInputs = allBuildInputs;
    shellHook = cfg.shellHook;
  }
  // cfg.env
)
// {
  debug = cfg.debug;
}
