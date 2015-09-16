include(CheckIncludeFile)

function(_find_include_dir _names _hints _result)
    find_path(_include_dir
        NAMES ${_names}
        HINTS ${_hints}
    )
    set(_all_include_files_work TRUE)
    foreach(_name ${_names})
        check_include_file(${_include_dir}/${_name} _include_file_works)
        if(NOT _include_file_works)
            set(_all_include_files_work FALSE)
        endif()
    endforeach()
    if(${_all_include_files_work})
        set(${_result} ${_include_dir} PARENT_SCOPE)
    endif()
endfunction()
