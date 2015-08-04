if(BLAS_FOUND)
    if(CMAKE_Fortran_COMPILER_ID MATCHES PGI)
        # we remove -rdynamic flag added by CMake
        # PGI Fortran does not recognize this flag
        SET(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS)
    endif()

    add_executable(example example.f90)
    target_link_libraries(example ${MATH_LIBS})
else()
    message(FATAL_ERROR "BLAS library not found for the test fc_blas!")
endif()
