{
  lib,
  stdenv,
  collectCMakePackages,
}:
{
  cmakeBuildInputs ? [ ],

  nativeBuildInputs ? [ ],
  cmakeFlags ? [ ],
  ...
}@args:
let
  allCMakePackages = builtins.concatLists (map collectCMakePackages cmakeBuildInputs);

  paths = map (p: "${p}/lib/cmake") allCMakePackages;

  argModPath = lib.concatStringsSep ";" paths;
  extraCMakeFlags = [ "-DCMAKE_MODULE_PATH=${argModPath}" ];
in
stdenv.mkDerivation (
  args
  // {
    nativeBuildInputs = nativeBuildInputs ++ cmakeBuildInputs;
    cmakeFlags = cmakeFlags ++ extraCMakeFlags;
  }
)
