{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.cmsis5 = {
    url = "github:ARM-software/CMSIS_5/2b7495b8535bdcb306dac29b9ded4cfb679d7e5c";
    flake = false;
  };
  inputs.cmsis-device-f3 = {
    url = "github:STMicroelectronics/cmsis-device-f3/5558e64e3675a1e1fcb1c71f468c7c407c1b1134";
    flake = false;
  };
  inputs.cmsis-device-f4 = {
    url = "github:STMicroelectronics/cmsis-device-f4/3c77349ce04c8af401454cc51f85ea9a50e34fc1";
    flake = false;
  };
  inputs.mbed-ce = {
    url = "github:mbed-ce/mbed-os/4ba00162ba2d73c64583018983391e1dfeaee83d";
    flake = false;
  };
  inputs.stm32f3xx-hal-driver = {
    url = "github:STMicroelectronics/stm32f3xx-hal-driver/ef8c84f93e990805571c056f206538793d011542";
    flake = false;
  };
  inputs.stm32f4xx-hal-driver = {
    url = "github:STMicroelectronics/stm32f4xx-hal-driver/edad1a8a23ec4d7d287df60f0992ca395c85395c";
    flake = false;
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,

      cmsis5,
      cmsis-device-f3,
      cmsis-device-f4,
      mbed-ce,
      stm32f3xx-hal-driver,
      stm32f4xx-hal-driver,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };

      roboenvPackages = import ./pkgs {
        inherit pkgs;
        lib = nixpkgs.lib;

        cLibs = {
          inherit
            cmsis5
            cmsis-device-f3
            cmsis-device-f4
            mbed-ce
            stm32f3xx-hal-driver
            stm32f4xx-hal-driver
            ;
        };
      };

    in
    rec {
      packages.x86_64-linux.test = devShells.${system}.default.debug.cmakePackages;

      legacyPackages.${system} = roboenvPackages;

      devShells.${system}.default = pkgs.callPackage ./shell.nix {
        inherit (roboenvPackages) roboenv;
      };

      template.application = {
        path = "${./templates/app}";
        description = "The Roboenv-nix template of project which makes a MCU application";
      };

      overlays.default =
        final: prev:
        import ./pkgs {
          pkgs = final;
          lib = final.lib;
        };

    };
}
