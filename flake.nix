{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.ikarashiCAN_mk2 = {
    url = "git+ssh://git@github.com:nnctroboticsclub/ikarashiCAN_mk2.git?rev=3f941b99b6cffd82d69da636d187eab3fec5ec2d";
    flake = false;
  };

  inputs.ikakoMDC = {
    url = "git+ssh://git@github.com:nnctroboticsclub/ikakoMDC.git?rev=156c6f30ca7d5d96542bae1edf4bad3487494c7a";
    flake = false;
  };

  inputs.ikako_rohm_md = {
    url = "git+ssh://git@github.com:nnctroboticsclub/ikako_rohm_md.git?rev=a39a09aa3014ed3c19aa81cfdbb309d3503aa98b";
    flake = false;
  };

  inputs.MotorController = {
    url = "git+ssh://git@github.com:nnctroboticsclub/MotorController.git?rev=aba526174f61a2b4e126b0bfa83311e292849e0e";
    flake = false;
  };

  inputs.IkakoRobomas = {
    url = "git+ssh://git@github.com:nnctroboticsclub/IkakoRobomas.git?rev=98336d610bb255c57565b571e47c404c0070d49d";
    flake = false;
  };

  inputs.can_servo = {
    url = "git+ssh://git@github.com:nnctroboticsclub/can_servo.git?rev=e68a8af81d92ede8c92f08270f93f54c58aa22ac";
    flake = false;
  };

  inputs.Futaba_Puropo = {
    url = "git+ssh://git@github.com:nnctroboticsclub/Futaba_Puropo.git?rev=2e5d6d59754e0f4622dc85e7a4ccaf80a666e47b";
    flake = false;
  };

  inputs.PS4_RX = {
    url = "git+ssh://git@github.com:nnctroboticsclub/PS4_RX.git?rev=0aca1751a597c3687bb994fff6c9b282ead224a0";
    flake = false;
  };

  inputs.srobo_base = {
    url = "git+ssh://git@github.com:nnctroboticsclub/srobo_base.git?rev=ecb75beae7ff503a26ce737951817ec6df0cd176";
    flake = false;
  };

  inputs.im920_rs = {
    url = "git+ssh://git@github.com:nnctroboticsclub/im920_rs.git?rev=fdde2c3a0a6591a6e8f294c49e550779eca69761";
    flake = false;
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,

      ikarashiCAN_mk2,
      ikakoMDC,
      ikako_rohm_md,
      MotorController,
      IkakoRobomas,
      can_servo,
      Futaba_Puropo,
      PS4_RX,
      srobo_base,
      im920_rs,
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

        cPkgs = {
          inherit
            ikarashiCAN_mk2
            ikakoMDC
            ikako_rohm_md
            MotorController
            IkakoRobomas
            can_servo
            Futaba_Puropo
            PS4_RX
            srobo_base
            im920_rs
            ;
        };
      };

    in
    {
      legacyPackages.${system} = roboenvPackages;

      devShells.${system}.default = pkgs.callPackage ./shell.nix {
        inherit (roboenvPackages) roboenv roboPackages;
      };

      overlays.default =
        final: prev:
        import ./pkgs {
          pkgs = final;
          lib = final.lib;
        };

    };
}
