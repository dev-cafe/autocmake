add_executable(example example.cpp)

if(BUILD_CUSTOM_BOOST)
    add_dependencies(example custom_boost)
endif()

set(_libs ${Boost_TIMER_LIBRARY} ${Boost_CHRONO_LIBRARY} ${Boost_SYSTEM_LIBRARY})

if(NOT ${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(_libs ${_libs} rt)
endif()

target_link_libraries(example ${_libs})
