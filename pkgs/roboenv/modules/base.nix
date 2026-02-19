{
  lib,
  rlib,
  config,

  ...
}:
{
  options = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "roboenv";
      description = "Name of the development environment";
    };

    buildInputs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "List of packages to include in the environment";
    };

    cmakeInputs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "List of CMake packages to include in the environment";
    };

    shellHook = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Shell hook script to run when entering the environment";
    };

    extraBuildInputs = lib.mkOption {
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = _: [ ];
      description = "Function that returns extra build inputs";
    };

    env = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Environment variables to set in the environment";
    };

    debug.cmakePackages = lib.mkOption {
      type = lib.types.package;
      default = [ ];
      description = "List of CMake packages to include in the environment for debugging";
    };
  };

  config =
    let
      cmakePackages = rlib.cmakeLinkJoin {
        pname = "cmake-packages";
        packages = builtins.concatLists (map rlib.collectCMakePackages config.cmakeInputs);
      };
    in
    {
      env.CMAKE_PREFIX_PATH = "${cmakePackages}";
      env.CMAKE_MODULE_PATH = "${cmakePackages}/lib/cmake";
      debug.cmakePackages = cmakePackages;
    };
}
