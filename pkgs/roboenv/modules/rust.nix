{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.rust = {
    enable = lib.mkEnableOption "Rust toolchain support";
  };

  config = lib.mkIf config.rust.enable {
    buildInputs = with pkgs; [
      (rust-bin.stable.latest.default.override {
        extensions = [ "rust-src" ];
        targets = [ "thumbv7em-none-eabi" ];
      })
      rust-analyzer
      rustfmt
      rustc
      clippy
      rust-cbindgen
      pkg-config
      udev
    ];

    env.RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };
}
