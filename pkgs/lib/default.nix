{
  callPackage,
}:
rec {
  collectCMakePackages = callPackage ./collectCMakePackages.nix { };
  buildCMakeProject = callPackage ./buildCMakeProject.nix { inherit collectCMakePackages; };
  flatAttr = callPackage ./flatAttr.nix { };
  scopeToAttrRecursive = callPackage ./scopeToAttrRecursive.nix { };
}
