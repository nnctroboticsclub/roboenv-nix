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

      pkgs = import nixpkgs {
        inherit system;
      };

      roboenv_overlay = pkgs.lib.composeManyExtensions [
        (import rust-overlay)
        (import ./pkgs/default.nix)
      ];

    in
    {
      overlays.default = roboenv_overlay;
    };
}
