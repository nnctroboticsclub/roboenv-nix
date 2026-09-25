{
  lib,
  stdenv,
  cmake,
  collectCMakePackages,
  roboenv-loader,
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

  argModPath = lib.concatStringsSep ";" (map (p: "${p}/lib/cmake") allCMakePackages);
  argPrefixPath = lib.concatStringsSep ";" (map (p: "${p}") allCMakePackages);

  extraCMakeFlags = lib.optionals (allCMakePackages != [ ]) [
    "-DCMAKE_MODULE_PATH=${argModPath}"
    "-DCMAKE_PREFIX_PATH=${argPrefixPath}"
  ];
  propagatedCMakeFlags = builtins.concatLists (
    map (p: p.propagatedCMakeFlags or [ ]) allCMakePackages
  );

in
stdenv.mkDerivation (
  args
  // {
    nativeBuildInputs = nativeBuildInputs ++ extraNativeBuildInputs ++ allCMakePackages;
    cmakeFlags = cmakeFlags ++ extraCMakeFlags ++ propagatedCMakeFlags;

    CMAKE_TOOLCHAIN_FILE = "${roboenv-loader}/lib/cmake/Roboenv.cmake";
  }
)
