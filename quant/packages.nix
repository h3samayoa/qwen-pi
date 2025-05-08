{ pkgs, llama-cpp-src }:

{
  llama-repo = pkgs.stdenv.mkDerivation {
    pname = "llama-repo";
    version = "unstable";

    src = llama-cpp-src;

    nativeBuildInputs = with pkgs; [ 
      cmake git curl 
    ] ++ lib.optionals stdenv.isDarwin [ darwin.cctools ];
      #++ lib.optionals stdenv.isLinux [ patchelf ]; todo ! add build script 

    dontUseCmakeConfigure = true;
    configurePhase = "echo skip"; # Nix expects a configurePhase to exist

    buildPhase = ''
      cmake -B build
      cmake --build build --config Release -j$(nproc || sysctl -n hw.ncpu)
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out/

      install_name_tool -add_rpath "@executable_path" $out/build/bin/llama-quantize
    '';
  };
}
