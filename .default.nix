let
  hostPkgs = import <nixpkgs> {};
  nixpkgs = (hostPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    rev = "nixos-unstable";
    sha256 = "1rc1pjnvfi194gka45zc1nivzsncc819kvxlfv277l2c8ryhgbpc";
  });
in
  with import nixpkgs {};
  stdenv.mkDerivation {
    name = "Autocmake";
    buildInputs = [
      ccache
      cmake
      doxygen
      gcc
      gfortran
      liblapack
      openmpi
      pipenv
      python3Packages.pep8
      python3Packages.pytest
      python3Packages.pyyaml
      zlib
    ];
    src = null;
    shellHook = ''
    export NINJA_STATUS="[Built edge %f of %t in %e sec]"
    SOURCE_DATE_EPOCH=$(date +%s)
    '';
  }
