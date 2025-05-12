{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "llama-repo";
  version = "unstable";

  src = pkgs.fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    rev = "141a908a59bbc68ceae3bf090b850e33322a2ca9";
    hash = "sha256-iMGzad3RaLlJxYg20lsHB49HctIaVxd9wBLAHd9j1xc=";
  };

  nativeBuildInputs = with pkgs; [ 
    cmake 
    git 
    curl 
  ]; ++ lib.optionals stdenv.isDarwin [ darwin.cctools ]
    ++ lib.optionals stdenv.isLinux [ patchelf ]; 

  #dontUseCmakeConfigure = true;
  configurePhase = "echo skip";

  buildPhase = ''
    cmake -B build
    cmake --build build --config Release -j$(nproc || sysctl -n hw.ncpu)
  '';

  installPhase = ''
    cp -r . $out/
  '';
}