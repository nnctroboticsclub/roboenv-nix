{
  stdenv,
  mbed-os-src,
}:

stdenv.mkDerivation {
  pname = "mbed-os";
  version = "0.1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/lib/cmake

    cp MbedCE-Toolchain.cmake $out/lib/cmake
    cp MbedCE.cmake $out/lib/cmake

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
