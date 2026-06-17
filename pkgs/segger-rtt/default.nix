{
  rlib,
  cmake,
  fetchFromGitHub,
  gcc-arm-toolchain,
}:
let
  src = fetchFromGitHub {
    # git@github.com:SEGGERMicro/RTT.git
    owner = "SEGGERMicro";
    repo = "RTT";
    tag = "V8.58.0";
    sha256 = "sha256-8NZ7njh7G2h1MjYHPHCpDfFWFown9wQ8hRuvN7JDiPw=";
  };
  pkg = rlib.buildCMakeProject {
    pname = "segger-rtt";
    version = "0.1.0";

    src = ./.;

    cmakeFlags = [ "-DRTT_SRC=${src}" ];

    cmakeBuildInputs = [ gcc-arm-toolchain ];

    nativeBuildInputs = [ cmake ];

    propagatedBuildInputs = [
      gcc-arm-toolchain
    ];
  };
in
pkg
