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
      self,

      nixpkgs,
      rust-overlay,

      nixos-wsl,
      home-manager,
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

      overlays.default =
        final: prev:
        import ./pkgs {
          pkgs = final;
          lib = final.lib;
        };

      nixosModules.default = {
        nix.settings.substituters = [
          "https://nnctrobo.cachix.org"
        ];
        nix.settings.trusted-public-keys = [
          "nnctrobo.cachix.org-1:1dKKIMpU2HT8hYTQVOxaE8YGT1rVvHpZNjgkMCrIRzM="
        ];
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      homeManagerModules.default = {
        programs.ssh.enable = true;

        programs.direnv.enable = true;
        programs.direnv.nix-direnv.enable = true;

        programs.zsh.enable = true;
        programs.direnv.enableZshIntegration = true;
      };

      nixosModules.robo-wsl = {
        imports = [
          nixos-wsl.nixosModules.default
          self.nixosModules.default
        ];

        wsl.enable = true;
        wsl.ssh-agent.enable = true;
        wsl.usbip.enable = true;
        wsl.interop.includePath = false;

        environment.systemPackages = [
          pkgs.wget
          pkgs.git
        ];

        # VSCode server fix
        programs.nix-ld.enable = true;
      };

      homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          self.homeManagerModules.default

          {
            home.username = "nixos";
            home.homeDirectory = "/home/nixos";
            home.stateVersion = "25.11";

            home.packages = [
              pkgs.nixd
              pkgs.nixfmt
            ];
          }
        ];
      };

      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          self.nixosModules.robo-wsl

          {
            system.stateVersion = "25.11";

            programs.zsh.enable = true;
            users.users.nixos.shell = pkgs.zsh;
            wsl.defaultUser = "nixos";
          }
        ];
      };
    };
}
