#.rst:
#
# Enables 64-bit integer support for Fortran projects.
#
# Variables modified (provided the corresponding language is enabled)::
#
#   CMAKE_Fortran_FLAGS
#
# autocmake.cfg configuration::
#
#   docopt: --int64 Enable 64bit integers [default: False].
#   define: '-DENABLE_64BIT_INTEGERS=%s' % arguments['--int64']

option(ENABLE_64BIT_INTEGERS "Enable 64-bit integers" OFF)

if(ENABLE_64BIT_INTEGERS)
    if(DEFINED CMAKE_Fortran_COMPILER_ID)
        if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
            set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fdefault-integer-8")
        endif()
        if(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
            set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -i8")
        endif()
        if(CMAKE_Fortran_COMPILER_ID MATCHES PGI)
            set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -i8")
        endif()
        if(CMAKE_Fortran_COMPILER_ID MATCHES XL)
            set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qintsize=8 -q64")
        endif()
    endif()
endif()
