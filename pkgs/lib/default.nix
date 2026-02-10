{
  callPackage,
}:
rec {
  collectCMakePackages = callPackage ./collectCMakePackages.nix { };
  buildCMakeProject = callPackage ./buildCMakeProject.nix { inherit collectCMakePackages; };
  cmakeLinkJoin = callPackage ./cmakeLinkJoin.nix { inherit collectCMakePackages; };
  flatAttr = callPackage ./flatAttr.nix { };
  scopeToAttrRecursive = callPackage ./scopeToAttrRecursive.nix { };
}
