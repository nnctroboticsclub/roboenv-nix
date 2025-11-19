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

      all_pkgs = rpkgs // tpkgs // cpkgs;
      packages = lib.scopeToAttrRecursive all_pkgs;
    in
    {
      packages.x86_64-linux = lib.flatAttr packages;

      devShells.x86_64-linux.default = import ./shell.nix {
        inherit pkgs rpkgs;
      };
    };
}
