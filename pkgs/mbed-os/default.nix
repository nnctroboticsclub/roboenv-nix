{
  stdenv,
  python311,
  roboPythonPackages,
  fetchgit,
}:
stdenv.mkDerivation rec {
  pname = "mbed-os";
  version = "0.2.0";

  src = ./.;
  mbed-ce = fetchgit {
    url = "https://github.com/mbed-ce/mbed-os.git";
    rev = "4ba00162ba2d73c64583018983391e1dfeaee83d";
    sha256 = "sha256-ZL7X1LY7OGdZpoSzcmgJt6idreX7BDcApmJUz8zfDpk=";
  };

  cmakeBuildInputs = [ ]; # Mark as CMake package

  pythonEnv = python311.withPackages (ps: [
    (roboPythonPackages.mbed_tools mbed-ce)
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
    set(mbed-ce_SOURCE_DIR ${mbed-ce})

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(mbed-ce
      REQUIRED_VARS
        mbed-ce_SOURCE_DIR
    )
    EOF
  '';
}
