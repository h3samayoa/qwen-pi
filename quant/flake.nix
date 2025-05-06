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
  in {
    packages = forAllSystems (pkgs: {
      llama-cpp = pkgs.callPackage "${self}/package.nix" {
        src = llama-cpp-src;
      };
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          python311
          python311Packages.pip
          python311Packages.setuptools
          python311Packages.transformers
          python311Packages.sentencepiece
          python311Packages.huggingface-hub
          git
          cmake
        ];
      };
    });
  };
}
