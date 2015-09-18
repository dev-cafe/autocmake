if(NOT CBLAS_FOUND)
    message(FATAL_ERROR "CBLAS not found")
endif()

if(NOT LAPACKE_FOUND)
    message(FATAL_ERROR "LAPACKE not found")
endif()

include_directories(${CBLAS_INCLUDE_DIR})
include_directories(${LAPACKE_INCLUDE_DIR})

add_executable(example example.cpp)

target_link_libraries(example ${LAPACKE_LIBRARIES})
