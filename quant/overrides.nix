{ pkgs }:

description = "override specific numpy and protobuf versions for poetry build"
let

  poetry-with-overrides = pkgs.python311.override {
    packageOverrides = self: super: {
      numpy = super.numpy,overridePythonAttrs (_: {
        version = "1.26.4";
        src = pkgs.fetchPypi {
          pname = "numpy";
          version = "1.26.4";
          sha256 = "REPLACE";
        };
      });

      protobuf = super.protobuf.overridePythonAttrs (_: {
        version = "4.24.4";
        src = pkgs.fetchPypi {
          pname = "protobuf";;
          sha256 = "REPLACE";
        };
      });
    };
  };
in 
  poetry-with-overrides