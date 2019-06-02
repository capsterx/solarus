# Declare the "solarus" library target and its public/private sources
# Note: will be STATIC or SHARED depending on BUILD_SHARED_LIBS=<ON|OFF>
add_library(solarus "")
include(cmake/SolarusLibrarySources.cmake)

# Add additional public/private sources for Apple systems
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  target_sources(solarus
    PUBLIC
      "${CMAKE_CURRENT_SOURCE_DIR}/include/solarus/core/AppleInterface.h"
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/src/core/AppleInterface.mm"
  )
endif()

# Declare the public/private libraries that "solarus" depends on
target_link_libraries(solarus
  PUBLIC
    "${SDL2_LIBRARY}"
    "${SDL2_IMAGE_LIBRARY}"
    "${SDL2_TTF_LIBRARY}"
    "${OPENGL_LIBRARY}"
    "${OPENAL_LIBRARY}"
    "${LUA_LIBRARY}"
    "${DL_LIBRARY}"
    "${PHYSFS_LIBRARY}"
    "${VORBIS_LIBRARY}"
    "${VORBISFILE_LIBRARY}"
    "${OGG_LIBRARY}"
    "${MODPLUG_LIBRARY}"
)

# Set the public/private compiler options required by "solarus"
target_compile_options(solarus
  PUBLIC
    "${SDL2_CFLAGS_OTHER}"
)

# Set the build properties for "solarus"
set_target_properties(solarus PROPERTIES
  VERSION ${PROJECT_VERSION}
  SOVERSION ${PROJECT_VERSION_MAJOR}
)

# Include additional configuration for macOS build and deployment
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  include(cmake/macOS/macOSBuild.cmake)
endif()
