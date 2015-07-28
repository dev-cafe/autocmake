#.rst:
#
# Enables OpenMP support.
#
# Variables used::
#
#   ENABLE_OPENMP
#   OPENMP_FOUND
#
# Variables modified (provided the corresponding language is enabled)::
#
#   CMAKE_Fortran_FLAGS
#   CMAKE_C_FLAGS
#   CMAKE_CXX_FLAGS
#
# autocmake.cfg configuration::
#
#   docopt: --omp Enable OpenMP parallelization [default: False].
#   define: '-DENABLE_OPENMP=%s' % arguments['--omp']

option(ENABLE_OPENMP "Enable OpenMP parallelization" OFF)

if(ENABLE_OPENMP)
    find_package(OpenMP)
    if(OPENMP_FOUND)
        if(DEFINED CMAKE_Fortran_COMPILER_ID)
            set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${OpenMP_C_FLAGS}")
        endif()
        if(DEFINED CMAKE_C_COMPILER_ID)
            set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
        endif()
        if(DEFINED CMAKE_CXX_COMPILER_ID)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
        endif()
    endif()
endif()
