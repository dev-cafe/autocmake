if(CMAKE_Fortran_COMPILER_ID MATCHES PGI)
    # remove -rdynamic flag offensive for PGI Fortran
    list(REMOVE_ITEM CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS "-rdynamic")
endif()

if(BLAS_FOUND)
    add_executable(example example.f90)
    target_link_libraries(example ${MATH_LIBS})
else()
    message(FATAL_ERROR "BLAS library not found for the test fc_blas!")
endif()
