{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/25.05";

  inputs.libs-cmake.url = "github:nnctroboticsclub/libs-cmake";
  inputs.libs-cmake.inputs.nixpkgs.follows = "nixpkgs";

  inputs.static-mbed-os.url = "github:nnctroboticsclub/static-mbed-os";
  inputs.static-mbed-os.inputs.libs-cmake.follows = "libs-cmake";
  inputs.static-mbed-os.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      nixpkgs,
      libs-cmake,
      static-mbed-os,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      cmake-libs = libs-cmake.packages.${system}.libs-cmake;
      gcc-arm-toolchain = libs-cmake.packages.${system}.gcc-arm-toolchain;
      mbed-os-f446re = static-mbed-os.packages.${system}.static-mbed-os-f446re;
      mbed-os-f303k8 = static-mbed-os.packages.${system}.static-mbed-os-f303k8;
    in
    rec {
      packages.x86_64-linux.cmake-libs = cmake-libs;
      packages.x86_64-linux.gcc-arm-toolchain = gcc-arm-toolchain;
      packages.x86_64-linux.static-mbed-os-f446re = mbed-os-f446re;
      packages.x86_64-linux.static-mbed-os-f303k8 = mbed-os-f303k8;

      packages.x86_64-linux.qemu-arm-xpack = pkgs.callPackage ./pkgs/qemu-arm-xpack.nix { };

      lib.collectCMakePackages =
        pkg:
        if builtins.hasAttr "cmakeBuildInputs" pkg && pkgs.lib.isDerivation pkg then
          let
            inputs = pkg.cmakeBuildInputs;
            cmakeInputs = builtins.concatLists (map lib.collectCMakePackages inputs);
          in
          cmakeInputs ++ [ pkg ]
        else
          [ ];

      lib.buildCMakeProject =
        {
          cmakeBuildInputs ? [ ],

          nativeBuildInputs ? [ ],
          cmakeFlags ? [ ],
          ...
        }@args:
        let
          allCMakePackages = builtins.concatLists (map lib.collectCMakePackages cmakeBuildInputs);

          paths = map (p: "${p}/lib/cmake") allCMakePackages;

          argModPath = pkgs.lib.concatStringsSep ";" paths;
          extraCMakeFlags = [ "-DCMAKE_MODULE_PATH=${argModPath}" ];
        in
        pkgs.stdenv.mkDerivation (
          args
          // {
            nativeBuildInputs = nativeBuildInputs ++ cmakeBuildInputs;
            cmakeFlags = cmakeFlags ++ extraCMakeFlags;
          }
        );

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
          packages.x86_64-linux.qemu-arm-xpack
          # Libs
          # mbed-os-f446re
          # mbed-os-f303k8
        ];
        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
      };
    };
}
