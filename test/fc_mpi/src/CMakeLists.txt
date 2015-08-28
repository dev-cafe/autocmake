if (MPI_FOUND)
    add_executable(example example.F90)
else()
    message(FATAL "MPI not found!")
endif()

