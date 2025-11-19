{ stdenv, cmake }:
stdenv.mkDerivation {
  pname = "cmake-libs";
  version = "1.0.0";

  src = ./.;
  nativeBuildInputs = [ cmake ];
}
// {
  cmakeBuildInputs = [ ];
}
