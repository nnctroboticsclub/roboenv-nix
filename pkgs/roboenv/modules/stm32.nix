{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.STM32 = {
    enable = lib.mkEnableOption "STM32 support";

    emulator = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "qemu-arm-xpack" ]);
      default = null;
      description = "The STM32 emulator to use";
    };
  };

  config = lib.mkIf config.STM32.enable {
    buildInputs = [
      pkgs.stlink
    ]
    ++ lib.optional (config.STM32.emulator != null) (
      if config.STM32.emulator == "qemu-arm-xpack" then
        pkgs.qemu-arm-xpack
      else
        throw "Unknown STM32 emulator: ${config.STM32.emulator}"
    );
  };
}
