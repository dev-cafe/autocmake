# Copyright (c) 2015 by Radovan Bast and Jonas Juselius
# see https://github.com/scisoft/cframe/blob/master/LICENSE

#-------------------------------------------------------------------------------

function(get_git_info
         in_python_executable
         out_git_last_commit_hash
         out_git_last_commit_author
         out_git_last_commit_date
         out_git_branch
         out_git_status_at_build)

    find_package(Git)
    if(GIT_FOUND)
        execute_process(
            COMMAND ${GIT_EXECUTABLE} rev-list --max-count=1 --abbrev-commit HEAD
            OUTPUT_VARIABLE _git_last_commit_hash
            ERROR_QUIET
            )

        if(_git_last_commit_hash)
            string(STRIP ${_git_last_commit_hash} _git_last_commit_hash)
        endif()

        execute_process(
            COMMAND ${GIT_EXECUTABLE} log --max-count=1 HEAD
            OUTPUT_VARIABLE _git_last_commit
            ERROR_QUIET
            )

        if(_git_last_commit)
            string(REGEX MATCH "Author:[ ]*(.+)<" temp "${_git_last_commit}")
            set(_git_last_commit_author ${CMAKE_MATCH_1})
            string(REGEX MATCH "Date:[ ]*(.+(\\+|-)[0-9][0-9][0-9][0-9])" temp "${_git_last_commit}")
            set(_git_last_commit_date ${CMAKE_MATCH_1})
        endif()

        execute_process(
            COMMAND ${in_python_executable} -c "import subprocess; import re; print(re.search(r'\\*.*', subprocess.Popen(['${GIT_EXECUTABLE}', 'branch'], stdout=subprocess.PIPE).communicate()[0], re.MULTILINE).group())"
            OUTPUT_VARIABLE _git_branch
            ERROR_QUIET
            )

        if(_git_branch)
            string(REPLACE "*" "" _git_branch ${_git_branch})
            string(STRIP ${_git_branch} _git_branch)
        endif()

        execute_process(
            COMMAND ${GIT_EXECUTABLE} status -uno
            OUTPUT_VARIABLE _git_status_at_build
            ERROR_QUIET
        )

        set(${out_git_last_commit_hash}   ${_git_last_commit_hash}   PARENT_SCOPE)
        set(${out_git_last_commit_author} ${_git_last_commit_author} PARENT_SCOPE)
        set(${out_git_last_commit_date}   ${_git_last_commit_date}   PARENT_SCOPE)
        set(${out_git_branch}             ${_git_branch}             PARENT_SCOPE)
        set(${out_git_status_at_build}    ${_git_status_at_build}    PARENT_SCOPE)
    else()
        set(${out_git_last_commit_hash}   "" PARENT_SCOPE)
        set(${out_git_last_commit_author} "" PARENT_SCOPE)
        set(${out_git_last_commit_date}   "" PARENT_SCOPE)
        set(${out_git_branch}             "" PARENT_SCOPE)
        set(${out_git_status_at_build}    "" PARENT_SCOPE)
    endif()
endfunction()

get_git_info(${PYTHON_EXECUTABLE}
             GIT_COMMIT_HASH
             GIT_COMMIT_AUTHOR
             GIT_COMMIT_DATE
             GIT_BRANCH
             GIT_STATUS_AT_BUILD)

# get configuration time in UTC
execute_process(
    COMMAND ${PYTHON_EXECUTABLE} -c "import datetime; print(datetime.datetime.utcnow())"
    OUTPUT_VARIABLE _configuration_time
    )
string(STRIP ${_configuration_time} _configuration_time) # delete newline

execute_process(
    COMMAND whoami
    TIMEOUT 1
    OUTPUT_VARIABLE _user_name
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )

execute_process(
    COMMAND hostname
    TIMEOUT 1
    OUTPUT_VARIABLE _host_name
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )

get_directory_property(_list_of_definitions DIRECTORY ${PROJECT_SOURCE_DIR} COMPILE_DEFINITIONS)

# set python version variable when it is not defined automatically
# this can happen when cmake version is equal or less than 2.8.5
if(NOT _python_version)
    execute_process(
        COMMAND ${PYTHON_EXECUTABLE} -V
        OUTPUT_VARIABLE _python_version
        ERROR_VARIABLE _python_version
        )
    string(REGEX MATCH "Python ([0-9].[0-9].[0-9])" temp "${_python_version}")
    set(_python_version ${CMAKE_MATCH_1})
endif()

configure_file(
    ${PROJECT_SOURCE_DIR}/cmake/lib/config_info.in.py
    ${PROJECT_BINARY_DIR}/config_info.py
    )

unset(_configuration_time)
unset(_user_name)
unset(_host_name)
unset(_list_of_definitions)
unset(_python_version)

exec_program(
    ${PYTHON_EXECUTABLE}
    ${PROJECT_BINARY_DIR}
    ARGS config_info.py Fortran > ${PROJECT_BINARY_DIR}/config_info.F90
    OUTPUT_VARIABLE _discard # we don't care about the output
    )

exec_program(
    ${PYTHON_EXECUTABLE}
    ${PROJECT_BINARY_DIR}
    ARGS config_info.py CMake > ${PROJECT_BINARY_DIR}/generated_by_cmake/config_info_generated.cmake
    OUTPUT_VARIABLE _discard # we don't care about the output
    )

include(config_info_generated)
