if(OPENMP_FOUND)
    add_executable(example example.f90)
else()
    message(FATAL_ERROR "OPENMP not found!")
endif()

