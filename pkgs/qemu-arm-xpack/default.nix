{ stdenv }:
stdenv.mkDerivation {
  name = "qemu-arm-xpack";
  src = fetchTarball {
    url = "https://github.com/xpack-dev-tools/qemu-arm-xpack/releases/download/v8.2.2-1/xpack-qemu-arm-8.2.2-1-linux-x64.tar.gz";
    sha256 = "sha256:1vfd3r8cf4p3wnx6drwvmlb04i9k62jix8rv8ni1c517a66d5fv0";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
    chmod +x $out/bin/*
  '';
}
