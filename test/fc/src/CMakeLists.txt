if(CMAKE_Fortran_COMPILER_ID MATCHES PGI)
    # we remove -rdynamic flag added by CMake
    # PGI Fortran does not recognize this flag
    SET(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS)
endif()

add_executable(example example.f90 module.f90)
