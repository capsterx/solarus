# Whether the user wants to install tools for testing quests
option(SOLARUS_TESTS_INSTALL "Install quest testing tools" OFF)

include(cmake/AddIncludeDirectories.cmake)
include(cmake/AddSolarusTestingLibrary.cmake)
include(cmake/AddTestMaps.cmake)
include(cmake/AddTests.cmake)
