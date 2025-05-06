{ stdenv, cmake, git, curl, src }:

stdenv.mkDerivation {
  name = "llama-cpp-main";
  inherit src;
  nativeBuildInputs = [ cmake git curl ];

}