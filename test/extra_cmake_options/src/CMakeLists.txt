# here we test setting -DENABLE_SOMETHING=OFF -DFOO=ON
# setup.py script
option(ENABLE_SOMETHING "Enable something" ON)
option(ENABLE_FOO "Enable FOO" OFF)

if(ENABLE_SOMETHING)
    message(FATAL_ERROR "This test failed")
endif()
if(NOT ENABLE_FOO)
    message(FATAL_ERROR "This test failed")
endif()

add_executable(example example.cpp)
