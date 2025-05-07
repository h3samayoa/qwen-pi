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
      default = pkgs.llama-cpp;
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          llama-cpp
          git
          cmake
          python311
          python311Packages.transformers
          python311Packages.sentencepiece
          python311Packages.huggingface-hub
          python311Packages.torch
          python311Packages.gguf
        ];
      };
    });
  };
}
