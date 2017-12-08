with import <nixpkgs> {}; {
  autocmakeEnv = stdenv.mkDerivation {
    name = "Autocmake";
    buildInputs = [
      atlas
      ccache
      clang
      cmake
      doxygen
      gfortran
      liblapack
      openmpi
      python35Packages.pep8
      python35Packages.pytest
      python35Packages.pyyaml
      zlib
    ];
  };
}
