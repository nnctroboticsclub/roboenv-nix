{
  lib,
  stdenv,
  cmake,
  collectCMakePackages,
  ccache
}:
{
  cmakeBuildInputs ? [ ],

  nativeBuildInputs ? [ ],
  cmakeFlags ? [ ],
  ...
}@args:
let
  allCMakePackages = builtins.concatLists (map collectCMakePackages cmakeBuildInputs);

  extraNativeBuildInputs = if lib.any (p: p == cmake) nativeBuildInputs then [ ] else [ cmake ];
  nativeBuildInputsFinal = extraNativeBuildInputs ++ allCMakePackages ++ [ ccache ];

  argModPath = lib.concatStringsSep ";" (map (p: "${p}/lib/cmake") allCMakePackages);
  argPrefixPath = lib.concatStringsSep ";" (map (p: "${p}") allCMakePackages);

  extraCMakeFlags = lib.optionals (allCMakePackages != [ ]) [
    "-DCMAKE_MODULE_PATH=${argModPath}"
    "-DCMAKE_PREFIX_PATH=${argPrefixPath}"
  ];

in
stdenv.mkDerivation (
  args
  // {
    nativeBuildInputs = nativeBuildInputs ++ nativeBuildInputsFinal;
    cmakeFlags = cmakeFlags ++ extraCMakeFlags;

    CCACHE_COMPRESS = 1;
    CCACHE_SLOPPINESS = "random_seed";
    CCACHE_DIR = "/nix/var/cache/ccache";
    CCACHE_UMASK = "007";
  }
)
