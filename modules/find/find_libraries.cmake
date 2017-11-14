# (c) https://github.com/coderefinery/autocmake/blob/master/AUTHORS.md
# licensed under BSD-3: https://github.com/coderefinery/autocmake/blob/master/LICENSE

include(CheckFunctionExists)

function(_find_library _names _check_function _result)
    if(APPLE)
        find_library(_lib
            NAMES ${_names}
            PATHS /usr/local/lib /usr/lib /usr/local/lib64 /usr/lib64
            ENV DYLD_LIBRARY_PATH
            )
    else()
        find_library(_lib
            NAMES ${_names}
            PATHS /usr/local/lib /usr/lib /usr/local/lib64 /usr/lib64
            ENV LD_LIBRARY_PATH
            )
    endif()
    set(CMAKE_REQUIRED_LIBRARIES ${_lib})
    check_function_exists(${_check_function} _library_works)
    if(${_library_works})
        set(${_result} ${_lib} PARENT_SCOPE)
    endif()
    unset(_lib CACHE)
endfunction()
