{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.llama-cpp-src = {
    url = "github:ggml-org/llama.cpp/141a908a59bbc68ceae3bf090b850e33322a2ca9";
    flake = false;
  };

  outputs = inputs @ { self, nixpkgs, llama-cpp-src, ... }: let

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
      default = (pkgs.callPackage ./packages.nix {
        llama-cpp-src = inputs.llama-cpp-src;
      }).llama-repo;
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        #inputsFrom = [ self.packages.${pkgs.system}.llama-cpp ];

        buildInputs = with pkgs; [
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
