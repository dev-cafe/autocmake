# (c) https://github.com/dev-cafe/autocmake/blob/master/AUTHORS.md
# licensed under BSD-3: https://github.com/dev-cafe/autocmake/blob/master/LICENSE

#.rst:
#
# Enable profiling by appending corresponding compiler flags.
#
# Variables modified (provided the corresponding language is enabled)::
#
#   CMAKE_Fortran_FLAGS
#   CMAKE_C_FLAGS
#   CMAKE_CXX_FLAGS
#
# autocmake.yml configuration::
#
#   docopt: "--profile Enable profiling [default: False]"
#   define: "'-DENABLE_PROFILING={0}'.format(arguments['--profile'])"

option(ENABLE_PROFILING "Enable profiling" OFF)

message(STATUS "Enable profiling: ${ENABLE_PROFILING}")

if(ENABLE_PROFILING)
    if(DEFINED CMAKE_Fortran_COMPILER_ID)
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -pg")
    endif()
    if(DEFINED CMAKE_C_COMPILER_ID)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -pg")
    endif()
    if(DEFINED CMAKE_CXX_COMPILER_ID)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -pg")
    endif()
endif()
