if(CMAKE_Fortran_COMPILER_ID MATCHES PGI)
# remove -rdynamic flag offensive to PGI Fortran
    SET(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS)
endif()
add_executable(example example.f90 module.f90)
