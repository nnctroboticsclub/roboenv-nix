{
  python311,
  mbed-os-src,
  roboPythonPackages,
}:
python311.withPackages (ps: [
  (roboPythonPackages.mbed_tools mbed-os-src)
  roboPythonPackages.cysecuretools
  roboPythonPackages.cryptography_36_0_1
])
