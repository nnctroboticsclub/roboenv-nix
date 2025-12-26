{ lib, pkgs, ... }:

config:

let
  stm32Packages =
    with pkgs;
    [
      stlink
    ]
    ++ lib.optional (config.emulator != null) (
      if config.emulator == "qemu-arm-xpack" then
        pkgs.qemu-arm-xpack
      else
        throw "Unknown STM32 emulator: ${config.emulator}"
    );

in
{
  buildInputs = if config.enable then stm32Packages else [ ];

  shellHook =
    if config.enable then
      ''
        # STM32 environment setup
      ''
    else
      "";
}
