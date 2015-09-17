if(LAPACK_FOUND)
    if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    #windows needs to find <lapacke.h> of openblas
        include_directories($ENV{PATH})
    else()
    #ftravis-ci needs find <clapack.h> of ATLAS
        include_directories(/usr/include/atlas)
    endif()
    add_executable(example example.cpp)
    target_link_libraries(example ${MATH_LIBS})
else()
    message(FATAL_ERROR "LAPACK library not found for the test cc_lapacke!")
endif()
