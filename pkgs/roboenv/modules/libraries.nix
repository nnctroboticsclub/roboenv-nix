{
  pkgs,
  rlib,
  ...
}:

libraries:

let
  # CMake パッケージを収集
  cmakePackages = builtins.concatLists (map rlib.collectCMakePackages libraries);

  # roboenv パッケージを作成
  roboPkg =
    if libraries != [ ] then
      pkgs.symlinkJoin {
        name = "roboenv-libraries";
        paths = cmakePackages;
      }
    else
      null;

in
{
  buildInputs = libraries;

  shellHook =
    if roboPkg != null then
      ''
        # Libraries environment setup
        export CMAKE_PREFIX_PATH="''${CMAKE_PREFIX_PATH:+$CMAKE_PREFIX_PATH;}${roboPkg}/lib/cmake"
        export CMAKE_MODULE_PATH="''${CMAKE_MODULE_PATH:+$CMAKE_MODULE_PATH;}${roboPkg}/lib/cmake"
      ''
    else
      "";
}
