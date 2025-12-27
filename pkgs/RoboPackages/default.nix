{ callPackage }:
let
  buildRoboPkg = callPackage ./buildRoboPkg.nix { };
in
rec {
  ikarashiCAN_mk2 = buildRoboPkg rec {
    pname = "ikarashiCAN_mk2";
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
    extraDependencies = [
      "Nano::HW::CompatMbed"
    ];
    libIncludes = [
      "${libSrc}"
      "${libSrc}/NoMutexCAN-master"
    ];
  };
  ikakoMDC = buildRoboPkg rec {
    pname = "ikakoMDC";
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
    libDependencies = [ ikarashiCAN_mk2 ];
    extraDependencies = [ "Nano::HW::CompatMbed" ];
    libIncludes = [
      "${libSrc}"
      "${libSrc}/lpf"
      "${libSrc}/PID"
    ];
  };
  ikako_rohm_md = buildRoboPkg rec {
    pname = "ikako_rohm_md";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/ikako_rohm_md.git";
      rev = "a39a09aa3014ed3c19aa81cfdbb309d3503aa98b";
    };
    libSources = [
      "${libSrc}/rohm_md.cpp"
    ];
    libDependencies = [ ikarashiCAN_mk2 ];
    extraDependencies = [ "Nano::HW::CompatMbed" ];
    libIncludes = [ "${libSrc}" ];
  };
  MotorController = buildRoboPkg rec {
    pname = "MotorController";
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
    libDependencies = [ ikarashiCAN_mk2 ];
    extraDependencies = [ "Nano::HW::CompatMbed" ];
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
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/can_servo.git";
      rev = "e68a8af81d92ede8c92f08270f93f54c58aa22ac";
    };
    libSources = [
      "${libSrc}/can_servo.cpp"
    ];
    libDependencies = [ ikarashiCAN_mk2 ];
    extraDependencies = [ "Nano::HW::CompatMbed" ];
    libIncludes = [
      "${libSrc}"
    ];
  };
  Futaba_Puropo = buildRoboPkg rec {
    pname = "Futaba_Puropo";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/Futaba_Puropo.git";
      rev = "2e5d6d59754e0f4622dc85e7a4ccaf80a666e47b";
    };
    libSources = [
      "${libSrc}/puropo.cpp"
    ];
    libDependencies = [ ];
    extraDependencies = [ "Nano::HW::CompatMbed" ];
    libIncludes = [ "${libSrc}" ];
  };
  PS4_RX = buildRoboPkg rec {
    pname = "PS4_RX";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/PS4_RX.git";
      rev = "0aca1751a597c3687bb994fff6c9b282ead224a0";
    };
    libSources = [
      "${libSrc}/PS4.cpp"
    ];
    libDependencies = [ ];
    extraDependencies = [ "Nano::HW::CompatMbed" ];
    libIncludes = [ "${libSrc}" ];
  };

  club-legacy-libs = callPackage ./club-legacy-libs { };

  srobo_base = buildRoboPkg rec {
    pname = "srobo_base";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/srobo_base.git";
      rev = "02a4a075264872246d83f3592f32fe59d1c858f6";
    };
    cmakeCompatible = true;
  };

  im920_rs = buildRoboPkg rec {
    pname = "im920_rs";
    version = "v1.0.0";
    libSrc = builtins.fetchGit {
      url = "git@github.com:nnctroboticsclub/im920_rs.git";
      rev = "2901c4ead3e00257d13c7344183c331147c9f36c";
    };
    cmakeCompatible = true;
  };
}