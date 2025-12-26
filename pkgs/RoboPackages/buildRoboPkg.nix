{
  stdenv,
  lib,
}:
{
  pname,
  version,
  libSrc,
  libSources,
  libDependencies ? [],
  extraDependencies ? [],
  libIncludes ? [ ],
}:
let
  libDeps = lib.concatLists [
    (lib.map (d: d.pname) libDependencies)
    extraDependencies
  ];
in
stdenv.mkDerivation {
  inherit pname version;
  src = ./.;

  LIB_NAME = pname;
  LIB_SRC = lib.concatStringsSep ";" libSources;
  LIB_INCLUDE = lib.concatStringsSep ";" libIncludes;
  LIB_DEPS = lib.concatStringsSep ";" libDeps;

  cmakeBuildInputs = libDependencies;

  buildPhase = ''
    bash build.sh > ${pname}Config.cmake
  '';
  installPhase = ''
    mkdir -p $out/lib/cmake/${pname}
    cp ${pname}Config.cmake $out/lib/cmake/${pname}/
  '';
}