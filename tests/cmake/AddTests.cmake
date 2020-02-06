# Sources in the 'src/tests' directory that are a test with a main() function
list(APPEND TEST_SOURCES
  src/tests/Initialization.cpp
  src/tests/MapData.cpp
  src/tests/LanguageData.cpp
  src/tests/PathFinding.cpp
  src/tests/PathMovement.cpp
  src/tests/PixelMovement.cpp
  src/tests/Quadtree.cpp
  src/tests/SpriteData.cpp
  src/tests/TilesetData.cpp
  src/tests/ShaderData.cpp
  src/tests/LuaMap.cpp
)

# Wrapper for add_test() to set root build path if we are in Windows
function(_add_test)
  add_test(${ARGN})
  if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set_tests_properties(${ARGV0} PROPERTIES
      ENVIRONMENT "PATH=${CMAKE_BINARY_DIR}\\;$ENV{PATH}"
    )
  endif()
endfunction(_add_test)

# Add all available test executables
foreach(TEST_SOURCE ${TEST_SOURCES})
  # Generate test name and executable target
  # Example: source=MapData.cpp, name=map-data, target=solarus-test-map-data
  get_filename_component(TEST_NAME ${TEST_SOURCE} NAME_WE)
  string(REGEX REPLACE "(.)([A-Z][a-z]+)" "\\1-\\2" TEST_NAME "${TEST_NAME}")
  string(TOLOWER "${TEST_NAME}" TEST_NAME)
  set(TEST_TARGET "solarus-test-${TEST_NAME}")

  # Add test executable and link to solarus-testing library
  add_executable(${TEST_TARGET} "")
  target_sources(${TEST_TARGET}
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_SOURCE}"
  )
  target_link_libraries(${TEST_TARGET}
    PUBLIC
      solarus-testing
  )
  set_target_properties(${TEST_TARGET} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin"
  )

  # Add test to ctest
  if (${TEST_NAME} STREQUAL "lua-map")
    # Lua map test: add an individual test for each map
    foreach(MAP_ID ${LUA_TEST_MAPS})
      _add_test("lua/${MAP_ID}" "bin/${TEST_TARGET}" -no-audio -no-video -turbo=yes "-map=${MAP_ID}" "${CMAKE_CURRENT_SOURCE_DIR}/testing_quest")
    endforeach()

    # Lua map test: add an individual test for each non-fatal map
    foreach(MAP_ID ${LUA_TEST_MAPS_NON_FATAL})
      _add_test("lua/${MAP_ID}" "bin/${TEST_TARGET}" -no-audio -no-video -turbo=yes -fatal-errors=no "-map=${MAP_ID}" "${CMAKE_CURRENT_SOURCE_DIR}/testing_quest")
    endforeach()

    # Lua map test: add an individual test for each map that requires a window to run
    foreach(MAP_ID ${LUA_TEST_MAPS_REQUIRE_WINDOW})
      _add_test("lua/${MAP_ID}" "bin/${TEST_TARGET}" -no-audio -turbo=yes "-map=${MAP_ID}" "${CMAKE_CURRENT_SOURCE_DIR}/testing_quest")
    endforeach()
  else()
    # Standard C++ test: for engine testing
    _add_test("${TEST_NAME}" "bin/${TEST_TARGET}" -no-audio -no-video -turbo=yes "${CMAKE_CURRENT_SOURCE_DIR}/testing_quest")
  endif()

  # Add install targets for "initialization" and "lua-map" tests
  if (SOLARUS_TESTS_INSTALL)
    if (${TEST_NAME} STREQUAL "initialization" OR ${TEST_NAME} STREQUAL "lua-map")
      install(TARGETS ${TEST_TARGET}
        ARCHIVE DESTINATION ${SOLARUS_LIBRARY_INSTALL_DESTINATION}
        LIBRARY DESTINATION ${SOLARUS_LIBRARY_INSTALL_DESTINATION}
        RUNTIME DESTINATION ${SOLARUS_EXECUTABLE_INSTALL_DESTINATION}
      )
    endif()
  endif()
endforeach()
