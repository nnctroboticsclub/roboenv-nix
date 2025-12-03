{
  stdenv,
  python311,
  roboPythonPackages,
}:
stdenv.mkDerivation rec {
  pname = "mbed-os";
  version = "0.2.0";

  src = builtins.fetchGit {
    url = "https://github.com/mbed-ce/mbed-os.git";
    ref = "master";
    rev = "4ba00162ba2d73c64583018983391e1dfeaee83d";
  };

  pythonEnv = python311.withPackages (ps: [
    (roboPythonPackages.mbed_tools src)
    roboPythonPackages.cysecuretools_6_0_0
    roboPythonPackages.cryptography_36_0_1
  ]);

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
    set(mbed-ce_SOURCE_DIR ${src})

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(mbed-ce
      REQUIRED_VARS
        mbed-ce_SOURCE_DIR
    )
    EOF
  '';
}
