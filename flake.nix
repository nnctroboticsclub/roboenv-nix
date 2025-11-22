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

      lib = pkgs.callPackage ./lib { };
      overlays = [ (import rust-overlay) ];

      pkgs = import nixpkgs { inherit system overlays; };
      rpkgs = import ./pkgs/default.nix {
        pkgs = pkgs;
        rlib = lib;
      };
      tpkgs = pkgs.callPackage ./tests {
        inherit (rpkgs) static-mbed-os-f446re;
        inherit (rpkgs) cmsis-device-f3;
        inherit (rpkgs) cmsis5;
        inherit (lib) buildCMakeProject;
      };

      all_pkgs = rpkgs // tpkgs;
      packages = lib.scopeToAttrRecursive all_pkgs;
    in
    {
      packages.x86_64-linux = lib.flatAttr packages;

      devShells.x86_64-linux.default = import ./shell.nix {
        inherit pkgs rpkgs;
      };
    };
}
