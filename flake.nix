{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-26.05";

  inputs.rust-overlay.url = "github:oxalica/rust-overlay";
  inputs.rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

  inputs.pyproject-nix.url = "github:pyproject-nix/pyproject.nix";
  inputs.pyproject-nix.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      self,

      nixpkgs,
      rust-overlay,
      pyproject-nix,
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };

      roboenvPackages = import ./pkgs {
        inherit pkgs;
        lib = nixpkgs.lib;
        inherit pyproject-nix;
      };

    in
    {
      legacyPackages.${system} = roboenvPackages;

      devShells.${system}.default = pkgs.callPackage ./shell.nix {
        inherit (roboenvPackages) roboenv;
      };

      templates.application = {
        path = "${./templates/app}";
        description = "The Roboenv-nix template of project which makes a MCU application";
      };

      templates.library = {
        path = "${./templates/lib}";
        description = "The Roboenv-nix template of project which makes a MCU library";
      };

      templates.dotfiles = {
        path = "${./templates/dotfiles}";
        description = "Configuration files for development environment";
      };

      overlays.default =
        final: prev:
        import ./pkgs {
          pkgs = final;
          lib = final.lib;
        };
    };
}
