{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-26.05";

  inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  inputs.nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      self,

      nixpkgs,

      nixos-wsl,
      home-manager,
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

    in
    {
      apps.rebuild-nixos = {
        type = "app";
        program = pkgs.writeShellScriptBin "rebuild" ''
          #!/usr/bin/env bash
          set -euo pipefail

          nixos-rebuild switch --flake .#default
        '';
      };
      apps.rebuild-home = {
        type = "app";
        program = pkgs.writeShellScriptBin "rebuild-home" ''
          #!/usr/bin/env bash
          set -euo pipefail

          nix run home-manager/master -- switch --flake .#default
        '';
      };
      homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          {
            home.username = "nixos";
            home.homeDirectory = "/home/nixos";
            home.stateVersion = "26.05";

            programs.ssh.enable = true;

            programs.zsh.enable = true;
            programs.direnv.enable = true;
            programs.direnv.nix-direnv.enable = true;
            programs.direnv.enableZshIntegration = true;

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
          {
            imports = [
              nixos-wsl.nixosModules.default
            ];

            wsl.enable = true;
            wsl.ssh-agent.enable = true;
            wsl.usbip.enable = true;
            wsl.interop.includePath = false;

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

            environment.systemPackages = [
              pkgs.wget
              pkgs.git
            ];

            # VSCode server fix
            programs.nix-ld.enable = true;
          }
        ];
      };
    };
}
