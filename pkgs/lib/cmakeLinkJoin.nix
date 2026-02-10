/*
  Generates a derivation named as "pname".
  It contains cmake link to each "packages".
  cmake link is the simple cmake code with following content:
  > include(<target cmake file>)

  CMake link targets has following path:
  - ABC/ABCConfig.cmake
  - AAA.cmake (Non folder wraps)
*/

{
  lib,
  stdenv,
  collectCMakePackages,
}:

{
  pname,
  packages,
}:

let
  allCMakePackages = builtins.concatLists (map collectCMakePackages packages);

  # Find all CMake files in a package with their relative paths
  findCMakeFiles =
    pkg:
    let
      cmakeDir = "${pkg}/lib/cmake";

      # Recursively find all .cmake files
      findInDir =
        dir: relPath:
        if builtins.pathExists dir then
          let
            entries = builtins.readDir dir;
            processEntry =
              name: type:
              let
                fullPath = "${dir}/${name}";
                newRelPath = if relPath == "" then name else "${relPath}/${name}";
              in
              if type == "directory" then
                findInDir fullPath newRelPath
              else if type == "regular" && (lib.hasSuffix ".cmake" name || lib.hasSuffix "Config.cmake" name) then
                [
                  {
                    inherit pkg;
                    path = newRelPath;
                    fullPath = fullPath;
                  }
                ]
              else
                [ ];
          in
          lib.flatten (lib.mapAttrsToList processEntry entries)
        else
          [ ];
    in
    findInDir cmakeDir "";

  # Collect all CMake files from all packages
  allCMakeFiles = lib.flatten (map findCMakeFiles allCMakePackages);

  # Generate install commands for each CMake file
  installCMakeFiles = lib.concatMapStringsSep "\n" (fileInfo: ''
        # Create trampoline for ${fileInfo.path}
        mkdir -p "$out/lib/cmake/$(dirname ${lib.escapeShellArg fileInfo.path})"
        cat > "$out/lib/cmake/${fileInfo.path}" << 'CMAKEEOF'
    include(${fileInfo.fullPath})
    CMAKEEOF
  '') allCMakeFiles;

in
stdenv.mkDerivation {
  name = pname;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib/cmake

    # Create trampoline files for each CMake config file
    ${installCMakeFiles}
  '';
}
