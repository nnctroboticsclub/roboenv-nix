{
  stdenv,
}:
stdenv.mkDerivation {
  pname = "mbed-os-src";
  version = "0.1.0";

  src = builtins.fetchGit {
    url = "https://github.com/mbed-ce/mbed-os.git";
    ref = "master";
    rev = "4ba00162ba2d73c64583018983391e1dfeaee83d";
  };

  installPhase = ''
    cp -r . $out
  '';
}
