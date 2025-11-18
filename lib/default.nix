{
  callPackage,
}:
rec {
  collectCMakePackages = callPackage ./collectCMakePackages.nix { };
  buildCMakeProject = callPackage ./buildCMakeProject.nix { inherit collectCMakePackages; };
}
