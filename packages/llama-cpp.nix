{ pkgs }:


pkgs.stdenv.mkDerivation {
  pname = "llama-repo";
  version = "unstable";

  src = pkgs.fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    rev = "141a908a59bbc68ceae3bf090b850e33322a2ca9";
    sha256 = "141a908a59bbc68ceae3bf090b850e33322a2ca9";
  };

  nativeBuildInputs = with pkgs; [ 
    cmake git curl 
  ] ++ lib.optionals stdenv.isDarwin [ darwin.cctools ]
    ++ lib.optionals stdenv.isLinux [ patchelf ]; 

  builder = ./build.sh
}