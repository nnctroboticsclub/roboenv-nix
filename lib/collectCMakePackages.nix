{ lib }:
let
  collectCMakePackages =
    pkg:
    if builtins.hasAttr "cmakeBuildInputs" pkg && lib.isDerivation pkg then
      let
        inputs = pkg.cmakeBuildInputs;
        cmakeInputs = builtins.concatLists (map collectCMakePackages inputs);
      in
      cmakeInputs ++ [ pkg ]
    else
      [ ];
in
collectCMakePackages
