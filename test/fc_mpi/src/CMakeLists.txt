if(MPI_FOUND)
    add_executable(example example.F90)
    if(CMAKE_SYSTEM_NAME MATCHES "Windows")
        # respect paths in appveyor.yml
        target_link_libraries(example "C:/software/msmpi/libmsmpi64.a")
    endif()
else()
    message(FATAL_ERROR "MPI not found!")
endif()

