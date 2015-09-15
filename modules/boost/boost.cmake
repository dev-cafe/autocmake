#.rst:
#
# Boost libraries detection and automatic build-up.
# Minimum required version of Boost and required components have to
# be specified separately in ``custom/boost_version-components.cmake``
# By "required components" we here mean compiled Boost libraries.
# This modules downloads the .zip archive from sourceforge at project
# bootstrap.
# Your autocmake.cfg should look like this::
#
#   [custom]
#   source: custom/boost_version-components.cmake
#
#   [boost]
#   source: https://github.com/scisoft/autocmake/raw/master/modules/boost/boost.cmake
#   fetch: http://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.zip
#
# The ``custom/boost_version-components.cmake`` should look like this::
#
#   set(BOOST_MINIMUM_REQUIRED 1.58.0)
#   list(APPEND BOOST_COMPONENTS_REQUIRED chrono timer system)
#
# Caveats:
#
# #. cross-dependencies between required components are not checked for.
#    For example, Boost.Timer depends on Boost.Chrono and Boost.System thus you
#    should ask explicitly for all three
# #. the project admin has to make sure that ``BOOST_MINIMUM_REQUIRED`` and the
#    ``fetch`` directive point to the same version of Boost
#
# Dependencies::
#
#   mpi                        - Only if the Boost.MPI library is a needed component
#   python_libs                - Only if the Boost.Python library is a needed component
#
# Variables used::
#
#   BOOST_MINIMUM_REQUIRED     - Minimum required version of Boost, set in ``custom/boost_version-components.cmake``
#   BOOST_COMPONENTS_REQUIRED  - Components (compiled Boost libraries) required
#   PROJECT_SOURCE_DIR
#   PROJECT_BINARY_DIR
#   CMAKE_BUILD_TYPE
#   MPI_FOUND
#
# Variables set::
#
# autocmake.cfg configuration::
#
#   fetch: https://github.com/scisoft/autocmake/raw/master/modules/boost/boost_unpack.cmake
#          https://github.com/scisoft/autocmake/raw/master/modules/boost/boost_userconfig.cmake
#          https://github.com/scisoft/autocmake/raw/master/modules/boost/boost_configure.cmake
#          https://github.com/scisoft/autocmake/raw/master/modules/boost/boost_build.cmake
#          https://github.com/scisoft/autocmake/raw/master/modules/boost/boost_install.cmake
#          https://github.com/scisoft/autocmake/raw/master/modules/boost/boost_headers.cmake
#          https://github.com/scisoft/autocmake/raw/master/modules/boost/boost_cleanup.cmake
#   docopt: --boost-headers=<BOOST_INCLUDEDIR> Include directories for Boost [default: ''].
#           --boost-libraries=<BOOST_LIBRARYDIR> Library directories for Boost [default: ''].
#           --build-boost=<FORCE_CUSTOM_BOOST> Deactivate Boost detection and build on-the-fly <ON/OFF> [default: OFF].
#   define: '-DBOOST_INCLUDEDIR="%s"' % arguments['--boost-headers']
#           '-DBOOST_LIBRARYDIR="%s"' % arguments['--boost-libraries']
#           '-DFORCE_CUSTOM_BOOST="%s"' % arguments['--build-boost']

# FIXME Maintainer should be able to choose between fail (end-user has to satisfy dependency
#       on its own) and soft-fail (self-build of Boost)
# Underscore-separated version number
string(REGEX REPLACE "\\." "_" BOOSTVER  ${BOOST_MINIMUM_REQUIRED})
# Where the Boost .zip archive is located
set(BOOST_ARCHIVE_LOCATION ${CMAKE_CURRENT_LIST_DIR})
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
    # Just to avoid unused variable warning from CMake
    set(BOOST_INCLUDEDIR "")
    set(BOOST_LIBRARYDIR "")
else(FORCE_CUSTOM_BOOST)
    find_package(Boost ${BOOST_MINIMUM_REQUIRED} COMPONENTS "${BOOST_COMPONENTS_REQUIRED}")
    if(NOT Boost_FOUND)
        set(BUILD_CUSTOM_BOOST TRUE)
    endif(NOT Boost_FOUND)
endif(FORCE_CUSTOM_BOOST)

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
    include(${CMAKE_CURRENT_LIST_DIR}/boost_unpack.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/boost_userconfig.cmake)
    if(BOOST_COMPONENTS_REQUIRED)
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
    else(BOOST_COMPONENTS_REQUIRED)
        # Empty list. Header-only libraries needed
        # Just unpack to known location
        message(STATUS "  No libraries required, installing headers")
        include(${CMAKE_CURRENT_LIST_DIR}/boost_headers.cmake)
    endif(BOOST_COMPONENTS_REQUIRED)
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
    include_directories(SYSTEM ${Boost_INCLUDE_DIRS})
    set(Boost_LIBRARY_DIRS ${Boost_LIBRARY_DIR})
    if(CMAKE_SYSTEM_NAME MATCHES "Linux")
        list(APPEND Boost_LIBRARIES rt)
    endif()
    link_directories(${Boost_LIBRARY_DIRS})
endif(BUILD_CUSTOM_BOOST)
