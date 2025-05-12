{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, nixos-hardware, agenix }:
    let
      forAllSystems = function:
        nixpkgs.lib.genAttrs [
          "aarch64-darwin" 
          "aarch64-linux" 
          "x86_64-linux"
        ] (system:
          function (import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          }));

      rpiSystem = "aarch64-linux";

      pkgsForRpi = import nixpkgs {
        system = rpiSystem;
        overlays = [
          (final: prev: {
            llama-cpp-custom = final.callPackage ./packages/llama-cpp.nix {};
          })
          agenix.overlays.default
        ];
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.raspberryPi5AP = nixpkgs.lib.nixosSystem {
        system = rpiSystem;
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-5

          agenix.nixosModules.default

          ./pi5/configuration.nix
          ./pi5/ap.nix
          ./pi5/tailscale.nix
          ./pi5/secrets.nix

          # rpi5 configuration and packages 
          ({ pkgs, ... }: {
            nixpkgs.pkgs = pkgsForRpi;

            environment.systemPackages = [
              pkgsForRpi.llama-cpp-custom
              pkgsForRpi.agenix
            ];

            sdImage.compressImage = true;
            sdImage.imageName = "nixos-rpi5-ap-llm.img";

            system.stateVersion = "24.05";
          })
        ];
      };

      formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);

      devShells = forAllSystems (pkgs:
        let
          devShellPkgs = import nixpkgs {
            inherit (pkgs) system;
            overlays = [ agenix.overlays.default ];
          };
          agenix-cli = devShellPkgs.agenix;
          age-cli = devShellPkgs.age;
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = [ 
              pkgs.nixpkgs-fmt 
              agenix-cli 
              age-cli
            ];
          };
        }
      );
    };
}
