{
  rlib,
  cmake,
  binutils,
  runCommand,
  gcc-arm-toolchain,
  segger-rtt,
}:

let
  testSrc = ./.;

  # Build test project with both targets
  testBuild = rlib.buildCMakeProject {
    pname = "segger-rtt-test";
    version = "0.1.0";
    src = testSrc;
    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DSeggerRTT_DIR=${segger-rtt}"
      "-DCMAKE_TOOLCHAIN_FILE=GccArmToolchain"
    ];
    nativeBuildInputs = [ cmake ];
    cmakeBuildInputs = [
      gcc-arm-toolchain
      segger-rtt
    ];
  };

  # Run tests: verify both binaries exist and have different config values
  runTests =
    runCommand "segger-rtt-test-results"
      {
        buildInputs = [ binutils ];
      }
      ''
        mkdir -p $out

        BOARD_A="${testBuild}/bin/board_a_firmware"
        BOARD_B="${testBuild}/bin/board_b_firmware"

        # Check both binaries exist
        test -f "$BOARD_A" || { echo "ERROR: board_a_firmware not found"; exit 1; }
        test -f "$BOARD_B" || { echo "ERROR: board_b_firmware not found"; exit 1; }

        # Extract config-related strings from both binaries
        STRINGS_CMD="strings"

        echo "=== Board A ===" | tee $out/results.txt
        $STRINGS_CMD "$BOARD_A" | grep "RTT_VAL_" | tee -a $out/results.txt

        echo -e "\n=== Board B ===" | tee -a $out/results.txt
        $STRINGS_CMD "$BOARD_B" | grep "RTT_VAL_" | tee -a $out/results.txt

        # Verify they're different (per-target config isolation)
        A_CONFIG=$($STRINGS_CMD "$BOARD_A" | grep "RTT_VAL_" | sort)
        B_CONFIG=$($STRINGS_CMD "$BOARD_B" | grep "RTT_VAL_" | sort)

        echo "DEBUG: A_CONFIG is '$A_CONFIG'"
        echo "DEBUG: B_CONFIG is '$B_CONFIG'"

        if [ -z "$A_CONFIG" ] || [ -z "$B_CONFIG" ]; then
          echo "ERROR: Could not extract config strings from binaries!"
          exit 1
        fi

        if [ "$A_CONFIG" = "$B_CONFIG" ]; then
          echo -e "\nERROR: Configs are identical - per-target isolation failed!" | tee -a $out/results.txt
          exit 1
        else
          echo -e "\nSUCCESS: Per-target configs are correctly isolated" | tee -a $out/results.txt
        fi
      '';

in
{
  build = testBuild;
  runTests = runTests;
}
