{
  stdenv,
  python3,
  fetchFromGitHub,
  pyproject-nix,
}:
let
  mbed-os-src = fetchFromGitHub {
    owner = "mbed-ce";
    repo = "mbed-os";
    rev = "64e236ffc7092033a8e6d7d79a5b14f7822f4350"; # mbed-os-7.0.0 tag の commit hash
    sha256 = "sha256-e4N1fLSGS3oaX6XgrMcloQDeXKjZo7pHpRfGdYiOunw=";
    fetchSubmodules = true;
  };
  project = pyproject-nix.lib.project.loadPyproject {
    projectRoot = mbed-os-src + "/tools";
  };
  mbed-tools = python3.pkgs.buildPythonPackage (
    (project.renderers.buildPythonPackage {
      python = python3;
    })
    // {
      importChecks = [ "mbed_tools.cli.cmsis_mcu_descr" ];
    }
  );
in
stdenv.mkDerivation {
  pname = "mbed-os";
  version = "0.2.0";

  src = mbed-os-src;
  mbed-tools = mbed-tools;

  pythonEnv = python3.withPackages (ps: [
    mbed-tools
  ]);

  cmakeBuildInputs = [ ];
  propagatedCMakeFlags = [
    # Git submodules are managed by nix, so MbedCE does not need to manage them
    "-DMBED_MANAGE_SUBMODULES=OFF"
  ];

  installPhase = ''
    mkdir -p $out/lib/cmake

    cat <<EOF > $out/lib/cmake/MbedCE-Toolchain.cmake
    find_package(mbed-ce REQUIRED)

    include(${"\\\${mbed-ce_SOURCE_DIR}"}/tools/cmake/mbed_toolchain_setup.cmake)
    EOF

    cat <<EOF > $out/lib/cmake/MbedCE.cmake
    # Called be after project()
    # Assumed MBedCE-Toolchain is already included before project()

    include(mbed_project_setup)
    add_subdirectory(${"\\\${mbed-ce_SOURCE_DIR}"} mbed-ce)
    EOF

    cat <<EOF > $out/lib/cmake/Findmbed-ce.cmake
    set(mbed-ce_SOURCE_DIR ${mbed-os-src})

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(mbed-ce
      REQUIRED_VARS
        mbed-ce_SOURCE_DIR
    )
    EOF
  '';
}
