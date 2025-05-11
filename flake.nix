# Root flake.nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }: let
    system = "aarch64-linux";

    pkgsFor = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages.${system}.llama-repo = pkgsFor system.callPackage ./packages/llama-cpp.nix {};

    nixosConfigurations.pi5 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./pi5/configuration.nix
        ./pi5/hardware-configuration.nix
        ./pi5/tailscale.nix
        ./modules/access-point.nix
        {
          environment.systemPackages = [
            self.packages.${system}.llama-repo
          ];
        }
      ];
    };
  };
}

