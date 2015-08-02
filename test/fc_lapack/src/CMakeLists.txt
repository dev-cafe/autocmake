if(LAPACK_FOUND)
    if(CMAKE_Fortran_COMPILER_ID MATCHES PGI)
        # remove -rdynamic flag offensive to PGI Fortran
        set(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS)
        # fix for rand() function
        add_definitions(-DVAR_PGI)
        message( "COMPILE_DEFINITIONS = ${COMPILE_DEFINITIONS}" )
    endif()
    add_executable(example example.F90)
    target_link_libraries(example ${MATH_LIBS})
else()
    message(FATAL_ERROR "LAPACK/BLAS libraries not found for the test fc_lapack!")
endif()
