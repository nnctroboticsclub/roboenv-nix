{ }:
let
  collectCMakePackages =
    pkg:
    if builtins.hasAttr "cmakeBuildInputs" pkg then
      [ pkg ]
      ++ builtins.concatLists (
        map (subpkg: [ subpkg ] ++ collectCMakePackages subpkg) pkg.cmakeBuildInputs
      )
    else
      [ ];
in
collectCMakePackages
