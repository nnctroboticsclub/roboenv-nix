{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/25.05";
  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,
      ...
    }:
    let
      system = "x86_64-linux";

      importable = args: import ./pkgs args;

    in
    {
      legacyPackages.${system} = importable {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };
        lib = nixpkgs.lib;
      };

      devShells.${system}.default =
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ rust-overlay.overlays.default ];
          };
          roboenvPackages = importable {
            inherit pkgs;
            lib = nixpkgs.lib;
          };
        in
        pkgs.callPackage ./shell.nix {
          inherit (roboenvPackages) roboenv roboPackages cmake-libs;
        };

      overlays.default =
        final: prev:
        importable {
          pkgs = final;
          lib = final.lib;
        };
    };
}
