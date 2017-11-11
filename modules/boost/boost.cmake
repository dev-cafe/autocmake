# (c) https://github.com/coderefinery/autocmake/blob/master/AUTHORS.md
# licensed under BSD-3: https://github.com/coderefinery/autocmake/blob/master/LICENSE

#.rst:
#
# Detect, build, and link Boost libraries.
# This modules downloads the .zip archive from SourceForge at
# Autocmake update time.
# Note that the build-up commands are not Windows-compatible!
#
# Your autocmake.yml should look like this::
#
# - boost:
#   - major: 1
#   - minor: 59
#   - patch: 0
#   - components: "chrono;timer;system"
#   - source: "https://github.com/coderefinery/autocmake/raw/master/modules/boost/boost.cmake"
#
# Cross-dependencies between required components are not checked for.
# For example, Boost.Timer depends on Boost.Chrono and Boost.System thus you
# should ask explicitly for all three.
# If the self-build of Boost components is triggered the `BUILD_CUSTOM_BOOST` variable is set
# to `TRUE`. The CMake target `custom_boost` is also added.
# You should use these two to ensure the right dependencies between your targets
# and the Boost headers/libraries, in case the self-build is triggered.
# For example::
#
#   if(BUILD_CUSTOM_BOOST)
#     add_dependencies(your_target custom_boost)
#   endif()
#
# will ensure that `your_target` is built after `custom_boost` if and only if the self-build
# of Boost took place. This is an important step to avoid race conditions when building
# on multiple processes.
#
# Dependencies::
#
#   mpi                        - Only if the Boost.MPI library is a needed component
#   python_libs                - Only if the Boost.Python library is a needed component
#
# Variables used::
#
#   BOOST_MINIMUM_REQUIRED     - Minimum required version of Boost
#   BOOST_COMPONENTS_REQUIRED  - Components (compiled Boost libraries) required
#   PROJECT_SOURCE_DIR
#   PROJECT_BINARY_DIR
#   CMAKE_BUILD_TYPE
#   MPI_FOUND
#   BUILD_CUSTOM_BOOST
#
# autocmake.yml configuration::
#
#   url_root: https://github.com/coderefinery/autocmake/raw/master/
#   major: 1
#   minor: 48
#   patch: 0
#   components: ""
#   fetch:
#     - "%(url_root)modules/boost/boost_unpack.cmake"
#     - "%(url_root)modules/boost/boost_userconfig.cmake"
#     - "%(url_root)modules/boost/boost_configure.cmake"
#     - "%(url_root)modules/boost/boost_build.cmake"
#     - "%(url_root)modules/boost/boost_install.cmake"
#     - "%(url_root)modules/boost/boost_headers.cmake"
#     - "%(url_root)modules/boost/boost_cleanup.cmake"
#     - "http://sourceforge.net/projects/boost/files/boost/%(major).%(minor).%(patch)/boost_%(major)_%(minor)_%(patch).zip"
#   docopt:
#     - "--boost-headers=<BOOST_INCLUDEDIR> Include directories for Boost [default: '']."
#     - "--boost-libraries=<BOOST_LIBRARYDIR> Library directories for Boost [default: '']."
#     - "--build-boost=<FORCE_CUSTOM_BOOST> Deactivate Boost detection and build on-the-fly <ON/OFF> [default: OFF]."
#   define:
#     - "'-DBOOST_INCLUDEDIR=\"{0}\"'.format(arguments['--boost-headers'])"
#     - "'-DBOOST_LIBRARYDIR=\"{0}\"'.format(arguments['--boost-libraries'])"
#     - "'-DFORCE_CUSTOM_BOOST={0}'.format(arguments['--build-boost'])"
#     - "'-DBOOST_MINIMUM_REQUIRED=\"%(major).%(minor).%(patch)\"'"
#     - "'-DBOOST_COMPONENTS_REQUIRED=\"%(components)\"'"

# FIXME Maintainer should be able to choose between fail (end-user has to satisfy dependency
#       on its own) and soft-fail (self-build of Boost)
# Underscore-separated version number
string(REGEX REPLACE "\\." "_" BOOSTVER ${BOOST_MINIMUM_REQUIRED})

# Where the Boost .zip archive is located
set(BOOST_ARCHIVE_LOCATION ${PROJECT_SOURCE_DIR}/cmake/downloaded)

set(BOOST_ARCHIVE boost_${BOOSTVER}.zip)

# FIXME These are possibly not always good settings
set(Boost_USE_STATIC_LIBS    ON)
set(Boost_USE_MULTITHREADED  ON)
set(Boost_USE_STATIC_RUNTIME OFF)
set(Boost_DEBUG OFF)
set(Boost_DETAILED_FAILURE_MESSAGE OFF)

set(BUILD_CUSTOM_BOOST FALSE)
if(FORCE_CUSTOM_BOOST)
    set(BUILD_CUSTOM_BOOST TRUE)
    message(STATUS "Force automatic build of Boost")
    # Just to avoid unused variable warning from CMake
    set(BOOST_INCLUDEDIR "")
    set(BOOST_LIBRARYDIR "")
else()
    # Read from cache, needed for rebuilds
    set(BOOST_INCLUDEDIR ${Boost_INCLUDE_DIR})
    set(BOOST_LIBRARYDIR ${Boost_LIBRARY_DIR})
    find_package(Boost ${BOOST_MINIMUM_REQUIRED} COMPONENTS "${BOOST_COMPONENTS_REQUIRED}")
    if(NOT Boost_FOUND)
        set(BUILD_CUSTOM_BOOST TRUE)
    endif()
endif()

if(BUILD_CUSTOM_BOOST)
    ## Preliminary work
    # 0. Root directory for the custom build
    set(CUSTOM_BOOST_LOCATION ${PROJECT_BINARY_DIR}/boost)
    file(MAKE_DIRECTORY ${CUSTOM_BOOST_LOCATION})
    # 1. Where Boost will be built
    set(BOOST_BUILD_DIR ${CUSTOM_BOOST_LOCATION}/boost_${BOOSTVER})
    # 2. Select toolset according to compilers specified by the user
    set(toolset   "")
    if(CMAKE_CXX_COMPILER_ID MATCHES Intel)
        set(toolset "intel-linux")
    elseif(CMAKE_CXX_COMPILER_ID MATCHES Clang)
        set(toolset "clang")
    else()
        if(CMAKE_SYSTEM_NAME MATCHES Darwin)
            set(toolset "darwin")
        else()
            set(toolset "gcc")
        endif()
    endif()
    string(TOLOWER ${CMAKE_BUILD_TYPE} type)

   # CMAKE_CURRENT_LIST_DIR is undefined in CMake 2.8.2
   # see https://public.kitware.com/Bug/print_bug_page.php?bug_id=11675
   # workaround: create CMAKE_CURRENT_LIST_DIR
    get_filename_component(CMAKE_CURRENT_LIST_DIR ${CMAKE_CURRENT_LIST_FILE} PATH)
    include(${CMAKE_CURRENT_LIST_DIR}/boost_unpack.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/boost_userconfig.cmake)

    if(NOT "${BOOST_COMPONENTS_REQUIRED}" STREQUAL "")
        # Non-empty list. Compiled libraries needed
        # Transform the ;-separated list to a ,-separated list (digested by the Boost build toolchain!)
        string(REPLACE ";" "," b2_needed_components "${BOOST_COMPONENTS_REQUIRED}")
        # Replace unit_test_framework (used by CMake's find_package) with test (understood by Boost build toolchain)
        string(REPLACE "unit_test_framework" "test" b2_needed_components "${b2_needed_components}")
        set(select_libraries "--with-libraries=${b2_needed_components}")
        string(REPLACE ";" ", " printout "${BOOST_COMPONENTS_REQUIRED}")
        message(STATUS "  Libraries to be built: ${printout}")
        message(STATUS "  Toolset to be used: ${toolset}")
        include(${CMAKE_CURRENT_LIST_DIR}/boost_configure.cmake)
        include(${CMAKE_CURRENT_LIST_DIR}/boost_build.cmake)
        include(${CMAKE_CURRENT_LIST_DIR}/boost_install.cmake)
    else()
        # Empty list. Header-only libraries needed
        # Just unpack to known location
        message(STATUS "  No libraries required, installing headers")
        include(${CMAKE_CURRENT_LIST_DIR}/boost_headers.cmake)
    endif()

    include(${CMAKE_CURRENT_LIST_DIR}/boost_cleanup.cmake)
    add_custom_target(custom_boost DEPENDS ${CUSTOM_BOOST_LOCATION}/boost.cleanedup)
    # 4. Set all variables related to Boost that find_package would have set
    set(Boost_FOUND TRUE)
    string(REGEX REPLACE "\\." "0" Boost_VERSION ${BOOST_MINIMUM_REQUIRED})
    math(EXPR Boost_MAJOR_VERSION "${Boost_VERSION} / 100000")
    math(EXPR Boost_MINOR_VERSION "${Boost_VERSION} / 100 % 1000")
    math(EXPR Boost_SUBMINOR_VERSION "${Boost_VERSION} % 100")
    set(Boost_LIB_VERSION ${Boost_MAJOR_VERSION}_${Boost_MINOR_VERSION})
    set(Boost_INCLUDE_DIR ${CUSTOM_BOOST_LOCATION}/include CACHE PATH "Boost include directory" FORCE)
    set(Boost_LIBRARY_DIR ${CUSTOM_BOOST_LOCATION}/lib CACHE PATH "Boost library directory" FORCE)

    foreach(_component ${BOOST_COMPONENTS_REQUIRED})
        string(TOUPPER ${_component} _COMP)
        set(Boost_${_COMP}_FOUND TRUE)
        set(Boost_${_COMP}_LIBRARY libboost_${_component}.a)
        set(Boost_${_COMP}_LIBRARY_DEBUG ${Boost_LIBRARY_DIR}/${Boost_${_COMP}_LIBRARY} CACHE FILEPATH "Boost ${_component} library (debug)" FORCE)
        set(Boost_${_COMP}_LIBRARY_RELEASE ${Boost_LIBRARY_DIR}/${Boost_${_COMP}_LIBRARY} CACHE FILEPATH "Boost ${_component} library (release)" FORCE)
        list(APPEND Boost_LIBRARIES ${Boost_${_COMP}_LIBRARY})
    endforeach()

    set(Boost_INCLUDE_DIRS ${Boost_INCLUDE_DIR})
    set(Boost_LIBRARY_DIRS ${Boost_LIBRARY_DIR})
    if(CMAKE_SYSTEM_NAME MATCHES Linux)
        list(APPEND Boost_LIBRARIES rt)
    endif()
endif()

include_directories(SYSTEM ${Boost_INCLUDE_DIRS})

link_directories(${Boost_LIBRARY_DIRS})
