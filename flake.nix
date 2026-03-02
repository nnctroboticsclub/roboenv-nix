{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-25.11";

  inputs.rust-overlay.url = "github:oxalica/rust-overlay";
  inputs.rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  inputs.nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      nixpkgs,
      rust-overlay,

      nixos-wsl,
      home-manager,

      ...
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
      };

    in
    rec {
      packages.x86_64-linux.test = devShells.${system}.default.debug.cmakePackages;

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

      overlays.default =
        final: prev:
        import ./pkgs {
          pkgs = final;
          lib = final.lib;
        };

      nixosConfigurations.robo-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager

          {
            wsl.enable = true;
            wsl.defaultUser = "nixos";
            users.users.nixos.shell = pkgs.zsh;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nixos = ./home.nix;

            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
            programs.git.enable = true;
            programs.zsh.enable = true;

            nix.settings.substituters = [
              "https://nnctrobo.cachix.org"
            ];
            nix.settings.trusted-public-keys = [
              "nnctrobo.cachix.org-1:1dKKIMpU2HT8hYTQVOxaE8YGT1rVvHpZNjgkMCrIRzM="
            ];

            # This value determines the NixOS release from which the default
            # settings for stateful data, like file locations and database versions
            # on your system were taken. It's perfectly fine and recommended to leave
            # this value at the release version of the first install of this system.
            # Before changing this value read the documentation for this option
            # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
            system.stateVersion = "25.05"; # Did you read the comment?
          }
        ];
      };
    };
}
