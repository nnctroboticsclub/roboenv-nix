{
  python311,
  mbed-os,
  roboPythonPackages,
}:
python311.withPackages (ps: [
  (roboPythonPackages.mbed_tools mbed-os.src)
  roboPythonPackages.cysecuretools_6_0_0
  roboPythonPackages.cryptography_36_0_1
])
