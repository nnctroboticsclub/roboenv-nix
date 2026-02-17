{ lib, config, ... }:
{
  options.tool.usb.enable = lib.mkEnableOption {
    description = "USB Tool";
  };

  config =
    let
      cfg = config.tool.usb;
    in
    lib.mkIf cfg.enable {
      shellHook = ''
        export PATH=$PATH:${./bin}
        echo "Added USB Tool"
        echo "  $ list-devices"
      '';
    };
}
