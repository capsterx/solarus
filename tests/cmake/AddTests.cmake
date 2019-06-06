# Source files of the 'src/tests' directory that are a test with a main() function
list(APPEND TESTS_MAIN_FILES
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
  src/tests/RunLuaTest.cpp
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

# Generate test executables
foreach(TEST_MAIN_FILE ${TESTS_MAIN_FILES})
  get_filename_component(TEST_BIN_FILE ${TEST_MAIN_FILE} NAME_WE)
  add_executable(${TEST_BIN_FILE} "")
  target_sources(${TEST_BIN_FILE}
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_MAIN_FILE}"
  )
  target_link_libraries(${TEST_BIN_FILE}
    PUBLIC
      solarus-testing
  )
  set_target_properties(${TEST_BIN_FILE} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin"
  )

  # Lua test runner: add an individual test for each map.
  if (${TEST_MAIN_FILE} MATCHES "src/tests/RunLuaTest.cpp")
    foreach(MAP_ID ${LUA_TEST_MAPS})
      _add_test("lua/${MAP_ID}" "bin/${TEST_BIN_FILE}" -no-audio -no-video -turbo=yes "-map=${MAP_ID}" "${CMAKE_CURRENT_SOURCE_DIR}/testing_quest")
    endforeach()
    # Tests that want to survive on errors.
    foreach(MAP_ID ${LUA_TEST_MAPS_NON_FATAL})
      _add_test("lua/${MAP_ID}" "bin/${TEST_BIN_FILE}" -no-audio -no-video -turbo=yes -fatal-errors=no "-map=${MAP_ID}" "${CMAKE_CURRENT_SOURCE_DIR}/testing_quest")
    endforeach()
    # Tests that need a window to run.
    foreach(MAP_ID ${LUA_TEST_MAPS_REQUIRE_WINDOW})
      _add_test("lua/${MAP_ID}" "bin/${TEST_BIN_FILE}" -no-audio -turbo=yes "-map=${MAP_ID}" "${CMAKE_CURRENT_SOURCE_DIR}/testing_quest")
    endforeach()
  else()
    # Normal C++ test.
    get_filename_component(TEST_NAME "${TEST_MAIN_FILE}" NAME_WE)
    string(TOLOWER "${TEST_NAME}" TEST_NAME)
    _add_test("${TEST_NAME}" "bin/${TEST_BIN_FILE}" -no-audio -no-video -turbo=yes "${CMAKE_CURRENT_SOURCE_DIR}/testing_quest")
  endif()
endforeach()
