{
  callPackage,
  cPkgs,
}:
let
  buildRoboPkg = callPackage ./buildRoboPkg.nix { };
in
rec {
  ikarashiCAN_mk2 = buildRoboPkg rec {
    pname = "ikarashiCAN_mk2";
    version = "v1.0.0";
    libSrc = cPkgs.ikarashiCAN_mk2;
    libSources = [
      "${libSrc}/ikarashiCAN_mk2.cpp"
    ];
    libDependencies = [ ];
    libNameonlyDependencies = [ "Nano::NanoHW_MbedIF" ];
    libIncludes = [
      "${libSrc}"
      "${libSrc}/NoMutexCAN-master"
    ];
  };
  ikakoMDC = buildRoboPkg rec {
    pname = "ikakoMDC";
    version = "v1.0.0";
    libSrc = cPkgs.ikakoMDC;
    libSources = [
      "${libSrc}/ikakoMDC.cpp"
      "${libSrc}/lpf/lpf.cpp"
      "${libSrc}/PID/PID.cpp"
    ];
    libDependencies = [ ikarashiCAN_mk2 ];
    libNameonlyDependencies = [ "Nano::NanoHW_MbedIF" ];
    libIncludes = [
      "${libSrc}"
      "${libSrc}/lpf"
      "${libSrc}/PID"
    ];
  };
  ikako_rohm_md = buildRoboPkg rec {
    pname = "ikako_rohm_md";
    version = "v1.0.0";
    libSrc = cPkgs.ikako_rohm_md;
    libSources = [
      "${libSrc}/rohm_md.cpp"
    ];
    libDependencies = [ ikarashiCAN_mk2 ];
    libNameonlyDependencies = [ "Nano::NanoHW_MbedIF" ];
    libIncludes = [ "${libSrc}" ];
  };
  MotorController = buildRoboPkg rec {
    pname = "MotorController";
    version = "v1.0.0";
    libSrc = cPkgs.MotorController;
    libSources = [
      "${libSrc}/MotorController.cpp"
      "${libSrc}/Ikako_PID/ikako_PID.cpp"
      "${libSrc}/DisturbanceObserver/DOB.cpp"
      "${libSrc}/DisturbanceObserver/LowPassFilter/LowPassFilter.cpp"
    ];
    libDependencies = [ ikarashiCAN_mk2 ];
    libNameonlyDependencies = [ "Nano::NanoHW_MbedIF" ];
    libIncludes = [
      "${libSrc}"
      "${libSrc}/Ikako_PID"
      "${libSrc}/DisturbanceObserver"
      "${libSrc}/DisturbanceObserver/LowPassFilter"
    ];
  };
  IkakoRobomas = buildRoboPkg rec {
    pname = "IkakoRobomas";
    version = "v1.0.0";
    libSrc = cPkgs.IkakoRobomas;
    libSources = [
      "${libSrc}/ikako_m2006.cpp"
      "${libSrc}/ikako_m3508.cpp"
      "${libSrc}/ikako_robomas.cpp"
    ];
    libDependencies = [
      ikarashiCAN_mk2
      MotorController
    ];
    extraDependencies = [ ];
    libIncludes = [
      "${libSrc}"
    ];
  };
  can_servo = buildRoboPkg rec {
    pname = "can_servo";
    version = "v1.0.0";
    libSrc = cPkgs.can_servo;
    libSources = [
      "${libSrc}/can_servo.cpp"
    ];
    libDependencies = [ ikarashiCAN_mk2 ];
    libNameonlyDependencies = [ "Nano::NanoHW_MbedIF" ];
    libIncludes = [
      "${libSrc}"
    ];
  };
  Futaba_Puropo = buildRoboPkg rec {
    pname = "Futaba_Puropo";
    version = "v1.0.0";
    libSrc = cPkgs.Futaba_Puropo;
    libSources = [
      "${libSrc}/puropo.cpp"
    ];
    libDependencies = [ ];
    libNameonlyDependencies = [ "Nano::NanoHW_MbedIF" ];
    libIncludes = [ "${libSrc}" ];
  };
  PS4_RX = buildRoboPkg rec {
    pname = "PS4_RX";
    version = "v1.0.0";
    libSrc = cPkgs.PS4_RX;
    libSources = [
      "${libSrc}/PS4.cpp"
    ];
    libDependencies = [ ];
    libNameonlyDependencies = [ "Nano::NanoHW_MbedIF" ];
    libIncludes = [ "${libSrc}" ];
  };

  club-legacy-libs = callPackage ./club-legacy-libs { };

  srobo_base = buildRoboPkg {
    pname = "srobo_base";
    version = "v1.0.0";
    libSrc = cPkgs.srobo_base;
    cmakeCompatible = true;
  };

  im920_rs = buildRoboPkg {
    pname = "im920_rs";
    version = "v1.0.0";
    libSrc = cPkgs.im920_rs;
    cmakeCompatible = true;
  };
}
