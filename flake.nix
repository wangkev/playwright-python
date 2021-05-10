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
      in {
        defaultPackage = pkgs.python3Packages.buildPythonPackage rec {
          name = "playwright";
          src = ./.;
        };

        # requisites for https://github.com/pypa/setuptools_scm/issues/278
        # SETUPTOOLS_SCM_DEBUG=1 python setup.py --version
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ 
            setuptools
            wheel 
          ];
        };
      }
    );
}