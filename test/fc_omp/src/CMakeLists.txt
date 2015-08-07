if (OPENMP_FOUND)
    add_executable(example example.f90)
else()
    message(FATAL "OPENMP not found!")
endif()

