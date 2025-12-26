{
  lib,
  pkgs,
  rlib,
  ...
}:

frameworks:

let
  # フレームワークごとのパッケージを生成
  frameworkPackages = map (
    fw:
    if fw.type == "StaticMbedOS" then
      pkgs.static-mbed-os {
        pname = "static-mbed-os-${lib.toLower fw.mbedTarget}";
        mbedTarget = fw.mbedTarget;
      }
    else if fw.type == "StaticMbedCE" then
      pkgs.static-mbed-ce {
        pname = "static-mbed-ce-${lib.toLower fw.mbedTarget}";
        mbedTarget = fw.mbedTarget;
      }
    else if fw.type == "STM32HAL" then
      if fw.family == "f3" then
        pkgs.stm32-hal-f3xx
      else if fw.family == "f4" then
        pkgs.stm32-hal-f4xx
      else
        throw "Unknown STM32 family: ${fw.family}"
    else
      throw "Unknown framework type: ${fw.type}"
  ) frameworks;

  # CMake パッケージを収集
  cmakePackages = builtins.concatLists (map rlib.collectCMakePackages frameworkPackages);

  # roboenv パッケージを作成
  roboPkg =
    if frameworks != [ ] then
      pkgs.symlinkJoin {
        name = "roboenv-frameworks";
        paths = cmakePackages;
      }
    else
      null;

in
{
  buildInputs = frameworkPackages;

  shellHook =
    if roboPkg != null then
      ''
        # Frameworks environment setup
        export CMAKE_PREFIX_PATH="''${CMAKE_PREFIX_PATH:+$CMAKE_PREFIX_PATH;}${roboPkg}/lib/cmake"
        export CMAKE_MODULE_PATH="''${CMAKE_MODULE_PATH:+$CMAKE_MODULE_PATH;}${roboPkg}/lib/cmake"
      ''
    else
      "";
}
