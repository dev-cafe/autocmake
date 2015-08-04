if(LAPACK_FOUND)
    if(CMAKE_Fortran_COMPILER_ID MATCHES PGI)
        # we remove -rdynamic flag added by CMake
        # PGI Fortran does not recognize this flag
        SET(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS)
    endif()

    add_executable(example example.F90)
    target_link_libraries(example ${MATH_LIBS})
else()
    message(FATAL_ERROR "LAPACK library not found for the test fc_lapack!")
endif()
