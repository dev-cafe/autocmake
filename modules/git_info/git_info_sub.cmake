#.rst:
#
# Creates git_info.h in the build directory.
# This file can be included in sources to print
# Git status information to the program output
# for reproducibility reasons.

find_package(Git)

set(_git_last_commit_hash "unknown")
set(_git_last_commit_author "unknown")
set(_git_last_commit_date "unknown")
set(_git_branch "unknown")

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
        string(STRIP ${_git_last_commit_author} _git_last_commit_author)
        string(REGEX MATCH "Date:[ ]*(.+(\\+|-)[0-9][0-9][0-9][0-9])" temp "${_git_last_commit}")
        set(_git_last_commit_date ${CMAKE_MATCH_1})
    endif()

    execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
        OUTPUT_VARIABLE _git_branch
        ERROR_QUIET
        )
    string(STRIP ${_git_branch} _git_branch)
endif()

configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/git_info.h.in
    ${_target_dir}/git_info.h
    @ONLY
    )

unset(_git_last_commit_hash)
unset(_git_last_commit_author)
unset(_git_last_commit_date)
unset(_git_branch)
