# Declare the "solarus-gui" library target and its public/private sources
# Note: will be STATIC or SHARED depending on BUILD_SHARED_LIBS=<ON|OFF>
add_library(solarus-gui "")
include(cmake/SolarusGuiLibrarySources.cmake)
include(cmake/SolarusGuiLibraryQtSources.cmake)

# Declare the public/private libraries that "solarus-gui" depends on
target_link_libraries(solarus-gui
  PUBLIC
    solarus
    Qt5::Widgets
)

# Set the build properties for "solarus-gui"
set_target_properties(solarus-gui PROPERTIES
  VERSION ${PROJECT_VERSION}
  SOVERSION ${PROJECT_VERSION_MAJOR}
)
