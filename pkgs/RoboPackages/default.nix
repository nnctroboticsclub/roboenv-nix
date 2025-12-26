{ callPackage }:
let
  buildRoboPkg = callPackage ./buildRoboPkg.nix { };
in
rec {
  ikarashiCAN_mk2-NUCLEO_F303K8 = buildRoboPkg rec {
    pname = "ikarashiCAN_mk2-NUCLEO_F303K8";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/ikarashiCAN_mk2.git";
      ref = version;
      rev = "3f941b99b6cffd82d69da636d187eab3fec5ec2d";
    };
    libSources = [
      "${libSrc}/ikarashiCAN_mk2.cpp"
    ];
    libDependencies = [ ];
    extraDependencies = ["StaticMbedOS-NUCLEO_F303K8"];
    libIncludes = [
      "${libSrc}"
      "${libSrc}/NoMutexCAN-master"
    ];
  };
  ikarashiCAN_mk2-NUCLEO_F446RE = ikarashiCAN_mk2-NUCLEO_F303K8.overrideAttrs {
    pname = "ikarashiCAN_mk2-NUCLEO_F446RE";
    extraDependencies = ["StaticMbedOS-NUCLEO_F446RE"];
  };


  ikakoMDC-NUCLEO_F303K8 = buildRoboPkg rec {
    pname = "ikakoMDC-NUCLEO_F303K8";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/ikakoMDC.git";
      rev = "156c6f30ca7d5d96542bae1edf4bad3487494c7a";
    };
    libSources = [
      "${libSrc}/ikakoMDC.cpp"
      "${libSrc}/lpf/lpf.cpp"
      "${libSrc}/PID/PID.cpp"
    ];
    libDependencies = [ ikarashiCAN_mk2-NUCLEO_F303K8 ];
    extraDependencies = ["StaticMbedOS-NUCLEO_F303K8"];
    libIncludes = [
      "${libSrc}"
      "${libSrc}/lpf"
      "${libSrc}/PID"
    ];
  };
  ikakoMDC-NUCLEO_F446RE = ikakoMDC-NUCLEO_F303K8.overrideAttrs {
    pname = "ikakoMDC-NUCLEO_F446RE";
    libDependencies = [ ikarashiCAN_mk2-NUCLEO_F446RE ];
    extraDependencies = ["StaticMbedOS-NUCLEO_F446RE"];
  };

  ikako_rohm_md-NUCLEO_F303K8 = buildRoboPkg rec {
    pname = "ikako_rohm_md-NUCLEO_F303K8";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/ikako_rohm_md.git";
      rev = "a39a09aa3014ed3c19aa81cfdbb309d3503aa98b";
    };
    libSources = [
      "${libSrc}/rohm_md.cpp"
    ];
    libDependencies = [ ikarashiCAN_mk2-NUCLEO_F303K8 ];
    extraDependencies = ["StaticMbedOS-NUCLEO_F303K8"];
    libIncludes = [ "${libSrc}" ];
  };

  ikako_rohm_md-NUCLEO_F446RE = ikako_rohm_md-NUCLEO_F303K8.overrideAttrs {
    pname = "ikako_rohm_md-NUCLEO_F446RE";
    libDependencies = [ ikarashiCAN_mk2-NUCLEO_F446RE ];
    extraDependencies = ["StaticMbedOS-NUCLEO_F446RE"];
  };

  MotorController-NUCLEO_F303K8 = buildRoboPkg rec {
    pname = "MotorController-NUCLEO_F303K8";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/MotorController.git";
      rev = "aba526174f61a2b4e126b0bfa83311e292849e0e";
    };
    libSources = [
      "${libSrc}/MotorController.cpp"
      "${libSrc}/Ikako_PID/ikako_PID.cpp"
      "${libSrc}/DisturbanceObserver/DOB.cpp"
      "${libSrc}/DisturbanceObserver/LowPassFilter/LowPassFilter.cpp"
    ];
    libDependencies = [ ikarashiCAN_mk2-NUCLEO_F303K8 ];
    extraDependencies = ["StaticMbedOS-NUCLEO_F303K8"];
    libIncludes = [
      "${libSrc}"
      "${libSrc}/Ikako_PID"
      "${libSrc}/DisturbanceObserver"
      "${libSrc}/DisturbanceObserver/LowPassFilter"
    ];
  };

  MotorController-NUCLEO_F446RE = MotorController-NUCLEO_F303K8.overrideAttrs {
    pname = "MotorController-NUCLEO_F446RE";
    libDependencies = [ ikarashiCAN_mk2-NUCLEO_F446RE ];
    extraDependencies = ["StaticMbedOS-NUCLEO_F446RE"];
  };

  IkakoRobomas-NUCLEO_F303K8 = buildRoboPkg rec {
    pname = "IkakoRobomas-NUCLEO_F303K8";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/IkakoRobomas.git";
      rev = "98336d610bb255c57565b571e47c404c0070d49d";
    };
    libSources = [
      "${libSrc}/ikako_m2006.cpp"
      "${libSrc}/ikako_m3508.cpp"
      "${libSrc}/ikako_robomas.cpp"
    ];
    libDependencies = [
      ikarashiCAN_mk2-NUCLEO_F303K8
      MotorController-NUCLEO_F303K8
    ];
    extraDependencies = [ ];
    libIncludes = [
      "${libSrc}"
    ];
  };

  IkakoRobomas-NUCLEO_F446RE = IkakoRobomas-NUCLEO_F303K8.overrideAttrs {
    pname = "IkakoRobomas-NUCLEO_F446RE";
    libDependencies = [
      ikarashiCAN_mk2-NUCLEO_F446RE
      MotorController-NUCLEO_F446RE
    ];
  };

  can_servo-NUCLEO_F303K8 = buildRoboPkg rec {
    pname = "can_servo-NUCLEO_F303K8";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/can_servo.git";
      rev = "e68a8af81d92ede8c92f08270f93f54c58aa22ac";
    };
    libSources = [
      "${libSrc}/can_servo.cpp"
    ];
    libDependencies = [ ikarashiCAN_mk2-NUCLEO_F303K8 ];
    extraDependencies = ["StaticMbedOS-NUCLEO_F303K8"];
    libIncludes = [
      "${libSrc}"
    ];
  };

  can_servo-NUCLEO_F446RE = can_servo-NUCLEO_F303K8.overrideAttrs {
    pname = "can_servo-NUCLEO_F446RE";
    libDependencies = [ ikarashiCAN_mk2-NUCLEO_F446RE ];
    extraDependencies = ["StaticMbedOS-NUCLEO_F446RE"];
  };

  Futaba_Puropo-NUCLEO_F303K8 = buildRoboPkg rec {
    pname = "Futaba_Puropo-NUCLEO_F303K8";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/Futaba_Puropo.git";
      rev = "2e5d6d59754e0f4622dc85e7a4ccaf80a666e47b";
    };
    libSources = [
      "${libSrc}/puropo.cpp"
    ];
    libDependencies = [ ];
    extraDependencies = ["StaticMbedOS-NUCLEO_F303K8"];
    libIncludes = [ "${libSrc}" ];
  };

  Futaba_Puropo-NUCLEO_F446RE = Futaba_Puropo-NUCLEO_F303K8.overrideAttrs {
    pname = "Futaba_Puropo-NUCLEO_F446RE";
    extraDependencies = ["StaticMbedOS-NUCLEO_F446RE"];
  };

  PS4_RX-NUCLEO_F303K8 = buildRoboPkg rec {
    pname = "PS4_RX-NUCLEO_F303K8";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/PS4_RX.git";
      rev = "0aca1751a597c3687bb994fff6c9b282ead224a0";
    };
    libSources = [
      "${libSrc}/PS4.cpp"
    ];
    libDependencies = [ ];
    extraDependencies = ["StaticMbedOS-NUCLEO_F303K8"];
    libIncludes = [ "${libSrc}" ];
  };

  PS4_RX-NUCLEO_F446RE = PS4_RX-NUCLEO_F303K8.overrideAttrs {
    pname = "PS4_RX-NUCLEO_F446RE";
    extraDependencies = ["StaticMbedOS-NUCLEO_F446RE"];
  };

  club-legacy-libs = callPackage ./club-legacy-libs { };
}
