{
  stdenv,
}:
stdenv.mkDerivation {
  pname = "cmsis5-src";
  version = "0.1.0";

  src = builtins.fetchGit {
    url = "https://github.com/ARM-software/CMSIS_5";
    ref = "5.9.0";
    rev = "2b7495b8535bdcb306dac29b9ded4cfb679d7e5c";
  };

  installPhase = ''
    cp -r . $out
  '';
}
