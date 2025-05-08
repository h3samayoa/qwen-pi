{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs @ { self, nixpkgs, ... }: let

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
  in {
    packages = forAllSystems (pkgs: {
      default = pkgs.callPackage ../packages/llama-cpp.nix {};
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          self.packages.${pkgs.system}.default
          (python311.withPackages (ps: with ps; [
            pip
            setuptools
            sentencepiece
            protobuf
            transformers
            huggingface-hub
            torch
            gguf
          ]))
        ];
      };
    });
  };
}
