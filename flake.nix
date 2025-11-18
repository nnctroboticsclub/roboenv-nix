{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/25.05";

  # inputs.libs-cmake.url = "github:nnctroboticsclub/libs-cmake";
  inputs.libs-cmake.url = "path:/mnt/data/ghq/github.com/syoch/libs-dev/libs/libs-cmake";
  inputs.libs-cmake.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      nixpkgs,
      libs-cmake,
      ...
    }:
    let
      system = "x86_64-linux";

      lib = pkgs.callPackage ./lib { };

      pkgs = import nixpkgs { inherit system; };
      cpkgs = libs-cmake.packages.${system};
      rpkgs = import ./pkgs/default.nix {
        pkgs = pkgs // cpkgs;
      };

      tpkgs = pkgs.callPackage ./tests {
        inherit (rpkgs) static-mbed-os-f446re;
        inherit (lib) buildCMakeProject;
      };
    in
    {
      packages.x86_64-linux = rpkgs;

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          clang-tools

          cargo
          rust-analyzer
          pkg-config
          udev
          rustfmt
          rustc
          clippy
          ccache
          dpkg
          ninja
          stlink-tool

          git-conventional-commits

          nix-output-monitor

          #* Migrated from robotics container
          # Tools
          gcc-arm-embedded-14
          cmake
          go-task
          rpkgs.qemu-arm-xpack
          # Libs
          # mbed-os-f446re
          # mbed-os-f303k8
        ];
        RUST_SRC_PATH = "${rpkgs.rustPlatform.rustLibSrc}";
      };
    };
}
