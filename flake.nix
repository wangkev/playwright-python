{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        auditwheel = pkgs.python3Packages.buildPythonPackage rec {
          pname = "auditwheel";
          version = "4.0.0";
          src = pkgs.python3Packages.fetchPypi {
            inherit pname version;
            sha256 = "sha256-A6B5/ic/QjNqzbWVP/XOdXj5PKaoMrFsg1/jN6HivUo=";
          };

          buildInputs = [
            pkgs.python3Packages.pyelftools
          ];
        };

      in {
        defaultPackage = pkgs.python3Packages.buildPythonPackage rec {
          name = "playwright";
          src = ./.;
          buildInputs = with pkgs.python3Packages; [ 
            auditwheel 
          ];
        };
      }
    );
}