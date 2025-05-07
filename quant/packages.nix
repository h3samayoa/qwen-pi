{ pkgs, llama-cpp-src }:

{
  llama-repo = pkgs.stdenv.mkDerivation {
    pname = "llama-repo";
    version = "unstable";

    src = llama-cpp-src;

    nativeBuildInputs = with pkgs; [ 
      cmake git curl 
    ] ++ lib.optionals stdenv.isDarwin [ darwin.cctools ]
      ++ lib.optionals stdenv.isLinux [ patchelf ];

    dontUseCmakeConfigure = true;
    configurePhase = "echo skip"; # Nix expects a configurePhase to exist

    buildPhase = ''
      cmake -B build
      cmake --build build --config Release -j$(nproc || sysctl -n hw.ncpu)
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
      
      for i in $out/bin/* do
        fileType=`file -b "$i"`

        case "$fileType" in
          *Mach-O*)
            install_name_tool -add_rpath "@executable_path" "$i"
            ;;
          *ELF*)
            patchelf --set-rpath "\$ORIGIN" "$i"
            ;;
          *)
            echo "skipping: "$i"
            ;;
        esac
      done
    '';
  };
}
