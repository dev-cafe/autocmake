# (c) https://github.com/coderefinery/autocmake/blob/master/AUTHORS.md
# licensed under BSD-3: https://github.com/coderefinery/autocmake/blob/master/LICENSE

# Unpack Boost
add_custom_command(
    OUTPUT ${CUSTOM_BOOST_LOCATION}/boost.unpacked
    COMMAND ${CMAKE_COMMAND} -E tar xzf ${BOOST_ARCHIVE_LOCATION}/${BOOST_ARCHIVE}
    COMMAND ${CMAKE_COMMAND} -E touch boost.unpacked
    DEPENDS ${BOOST_ARCHIVE_LOCATION}/${BOOST_ARCHIVE}
    WORKING_DIRECTORY ${CUSTOM_BOOST_LOCATION}
    COMMENT "Unpacking Boost")
