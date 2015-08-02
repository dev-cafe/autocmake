if(CMAKE_Fortran_COMPILER_ID MATCHES PGI)
    # remove -rdynamic flag offensive for PGI Fortran
    list(REMOVE_ITEM CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS "-rdynamic")
endif()

if(CMAKE_Fortran_COMPILER_ID MATCHES Intel AND ENABLE_STATIC_LINKING)
    # prevent "ifort: ... warning #10121: overriding '-static-intel' with '-i_dynamic'"
    list(REMOVE_ITEM CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS "-i_dynamic")
endif()

if(LAPACK_FOUND)
    add_executable(example example.F90)
    target_link_libraries(example ${MATH_LIBS})
else()
    message(FATAL_ERROR "LAPACK library not found for the test fc_lapack!")
endif()
