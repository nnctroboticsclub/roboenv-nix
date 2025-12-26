{ pkgs, ... }:
config:
let
  rustPackages = with pkgs; [
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

in
{
  buildInputs = if config.enable then rustPackages else [ ];

  shellHook =
    if config.enable then
      ''
        # Rust environment setup
        export RUST_SRC_PATH="${pkgs.rustPlatform.rustLibSrc}"
      ''
    else
      "";
}
