{
  stdenv,
  lib,
}:
{
  pname,
  version,
  libSrc,

  # CMake Wrapper
  libSources ? [ ],
  libIncludes ? [ ],
  libDependencies ? [ ],
  extraDependencies ? [ ],
  libNameonlyDependencies ? [ ],

  # CMake Compat
  cmakeCompatible ? false,
}:
stdenv.mkDerivation {
  inherit pname version;
  src = ./.;

  LIB_NAME = pname;

  LIB_ROOT = libSrc;
  LIB_SRC = lib.concatStringsSep ";" libSources;
  LIB_INCLUDE = lib.concatStringsSep ";" libIncludes;
  LIB_DEPS = lib.concatStringsSep ";" (
    lib.concatLists [
      (lib.map (d: d.pname) libDependencies)
      extraDependencies
    ]
  );
  LIB_DEPS_NAMEONLY = lib.concatStringsSep ";" libNameonlyDependencies;

  cmakeBuildInputs = libDependencies;

  buildPhase =
    if cmakeCompatible then
      ''
        bash build-cmake-compat.sh > ${pname}Config.cmake
      ''
    else
      ''
        bash build-cmake-wrapper.sh > ${pname}Config.cmake
      '';
  installPhase = ''
    mkdir -p $out/lib/cmake/${pname}
    cp ${pname}Config.cmake $out/lib/cmake/${pname}/
  '';
}
