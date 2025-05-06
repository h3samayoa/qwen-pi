{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    llama-cpp-src = {
      url = "github:ggerganov/llama.cpp/764b85627b46f43d7ea801867cd1b6abef484574";
      flake = false;
    };
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
        }));
    
    llamaPoetry = pkgs:
      let
        poetry-with-overrides = import ./overrides.nix { inherit pkgs; };
      in
        poetry-with-overrides.pkgs.buildPythonPackage {
          pname = "llama-cpp-tools";
          version = "unstable";
          format = "pyproject";
          src = llama-cpp-src;

          nativeBuildInputs = with poetry-with-overrides.pkgs; [
            poetry-core
          ];

          propagatedBuildInputs = with poetry-with-overrides.pkgs; [
            torch
            transformers
            sentencepiece
            huggingface-hub
            numpy
            protobuf
          ];
        };

  in {
    packages = forAllSystems (pkgs: {
      llama-cpp = pkgs.callPackage ./package.nix {
        src = llama-cpp-src;
      };
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          python311
          (llamaPoetry pkgs)
          git
          cmake
        ];
      };
    });
  };
}
