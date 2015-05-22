option(ENABLE_MPI "Enable MPI parallelization" OFF)

# on Cray configure with -D MPI_FOUND=1
if(ENABLE_MPI AND NOT MPI_FOUND)
    find_package(MPI)
    if(MPI_FOUND)
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${MPI_COMPILE_FLAGS}")
        include_directories(${MPI_INCLUDE_PATH})
    else()
        message(FATAL_ERROR "-- You asked for MPI, but CMake could not find any MPI installation, check $PATH")
    endif()
endif()
