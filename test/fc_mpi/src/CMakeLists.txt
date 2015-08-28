if (MPI_FOUND)
    add_executable(example example.f90)
    if (CMAKE_SYSTEM_NAME MATCHES "Windows")
        # path in appveyor.yml
        #target_link_libraries(example "C:\software\msmpi\libmsmpi64.a")
        target_link_libraries(example "C:/software/msmpi/libmsmpi64.a")
    endif()
else()
    message(FATAL "MPI not found!")
endif()

