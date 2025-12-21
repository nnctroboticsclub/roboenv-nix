{ stdenv, cmake }:
stdenv.mkDerivation {
  pname = "club-legacy-libs";
  version = "1.0.0";

  src = ./.;
  nativeBuildInputs = [ cmake ];
}
// {
  cmakeBuildInputs = [ ];
}
