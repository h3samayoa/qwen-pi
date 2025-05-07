{ pkgs, llama-cpp-src }:

{
  llama-cpp = pkgs.stdenv.mkDerivation {
    pname = "llama-cpp";
    version = "unstable";

    src = llama-cpp-src;

    nativeBuildInputs = [ pkgs.cmake ];

    buildPhase = ''
      cmake -B build
      cmake --build build --config Release
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };
}
