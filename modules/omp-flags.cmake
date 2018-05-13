# (c) https://github.com/coderefinery/autocmake/blob/master/AUTHORS.md
# licensed under BSD-3: https://github.com/coderefinery/autocmake/blob/master/LICENSE

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
# autocmake.yml configuration::
#
#   docopt: "--omp Enable OpenMP parallelization [default: False]."
#   define: "'-DENABLE_OPENMP={0}'.format(arguments['--omp'])"

option(ENABLE_OPENMP "Enable OpenMP parallelization" OFF)

if(ENABLE_OPENMP)

    if(NOT OPENMP_FOUND)
        find_package(OpenMP)
    endif()

    foreach(_lang C CXX Fortran)
        if(DEFINED CMAKE_${_lang}_COMPILER_ID)
            if(OPENMP_FOUND OR OpenMP_${_lang}_FOUND)
                set(CMAKE_${_lang}_FLAGS "${CMAKE_${_lang}_FLAGS} ${OpenMP_${_lang}_FLAGS}")
            endif()
        endif()
    endforeach()

    if(CMAKE_VERSION VERSION_LESS "3.5")
        if(DEFINED CMAKE_Fortran_COMPILER_ID AND NOT DEFINED OpenMP_Fortran_FLAGS)
            # we do this in a pedestrian way because the Fortran support is relatively recent
            if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
                set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fopenmp")
            endif()
            if(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
                if(WIN32)
                    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Qopenmp")
                elseif("${CMAKE_Fortran_COMPILER_VERSION}" VERSION_LESS "15.0.0.20140528")
                    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -openmp")
                else()
                    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qopenmp")
                endif()
            endif()
            if(CMAKE_Fortran_COMPILER_ID MATCHES PGI)
                set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -mp")
            endif()
            if(CMAKE_Fortran_COMPILER_ID MATCHES XL)
                set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qsmp=omp")
            endif()
            if(CMAKE_Fortran_COMPILER_ID MATCHES Cray)
                # do nothing in this case
            endif()
        endif()
    endif()
endif()
