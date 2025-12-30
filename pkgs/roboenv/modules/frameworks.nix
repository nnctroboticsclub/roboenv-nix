{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.frameworks = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          type = lib.mkOption {
            type = lib.types.enum [
              "StaticMbedOS"
              "StaticMbedCE"
              "STM32HAL"
            ];
            description = "The framework type";
          };

          mbedTarget = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "The Mbed target (for StaticMbedOS and StaticMbedCE)";
          };

          family = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.enum [
                "f3"
                "f4"
              ]
            );
            default = null;
            description = "The STM32 family (for STM32HAL)";
          };
        };
      }
    );
    default = [ ];
    description = "List of frameworks to include";
  };

  config =
    let
      # フレームワークごとのパッケージを生成
      frameworkPackages = map (
        fw:
        if fw.type == "StaticMbedOS" then
          pkgs.static-mbed-os {
            pname = "static-mbed-os-${lib.toLower fw.mbedTarget}";
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
      ) config.frameworks;
    in
    {
      cmakeInputs = frameworkPackages;
    };
}
