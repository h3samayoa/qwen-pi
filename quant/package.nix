{ stdenv, cmake, src }:

stdenv.mkDerivation {
  name = "llama-cpp-main";
  inherit src;
  nativeBuildInputs = [ cmake ];

  buildPhase = ''
    cmake -B build -DCMAKE_BUILD_TYPE=Release
    cmake --build build --config Release -j$(nproc || sysctl -n hw.ncpu)
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/main $out/bin/
  '';
}