{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/25.05";

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";

      lib = pkgs.callPackage ./lib { };

      pkgs = import nixpkgs { inherit system; };
      rpkgs = import ./pkgs/default.nix {
        pkgs = pkgs;
      };
      tpkgs = pkgs.callPackage ./tests {
        inherit (rpkgs) static-mbed-os-f446re;
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
