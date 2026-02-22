{
  stdenv,
}:
stdenv.mkDerivation {
  name = "roboenv-cmake-loader";
  src = ./.;
  installPhase = ''
    mkdir -p $out/lib/cmake
    cp $src/Roboenv.cmake $out/lib/cmake/
  '';
}
