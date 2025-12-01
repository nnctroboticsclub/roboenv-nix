{
  stdenv,
  lib,
}:
{
  pname ? "ikarashiCAN_mk2",
  version ? "v1.0.0",
  libSrc ? builtins.fetchGit {
    url = "git@github.com:nnctroboticsclub/${pname}.git";
    ref = version;
    rev = "3f941b99b6cffd82d69da636d187eab3fec5ec2d";
  },
  libSources ? [
    "${libSrc}/ikarashiCAN_mk2.cpp"
  ],
  libDependencies ? [ ],
  extraDependencies ? [
    "StaticMbedOS"
  ],
  libIncludes ? [
    "${libSrc}"
    "${libSrc}/NoMutexCAN-master"
  ],
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
