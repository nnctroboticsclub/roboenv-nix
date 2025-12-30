{
  config,
  lib,
  rlib,
  ...
}:
{
  options.libraries = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    description = "List of libraries to include";
  };

  config = {
    cmakeInputs = builtins.concatLists (map rlib.collectCMakePackages config.libraries);
  };
}
