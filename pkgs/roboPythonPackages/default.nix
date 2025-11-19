{ pkgs }:
let
  pythonScope = pkgs.python311Packages;
  self = pkgs.lib.fix (
    self:
    let
      callPkg = pkgs.lib.callPackageWith (pkgs // pythonScope // self);
      packages = import ./packages.nix;
    in
    packages { callPackage = callPkg; }
  );
in
self
