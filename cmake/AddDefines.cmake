# Solarus-specific -D preprocessor constants.

# Quest to launch if none is specified at runtime.
set(SOLARUS_DEFAULT_QUEST "." CACHE STRING "Path to the quest to launch if none is specified at runtime.")
if(SOLARUS_DEFAULT_QUEST)
  add_definitions(-DSOLARUS_DEFAULT_QUEST=\"${SOLARUS_DEFAULT_QUEST}\")
endif()

# Directory where to write savegames and other files saved by quests.
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(SOLARUS_INITIAL_WRITE_DIR "Solarus")
else()
  set(SOLARUS_INITIAL_WRITE_DIR ".solarus")
endif()
set(SOLARUS_WRITE_DIR ${SOLARUS_INITIAL_WRITE_DIR} CACHE STRING "Directory where Solarus savegames are stored, relative to the user's base write directory.")
if(SOLARUS_WRITE_DIR)
  add_definitions(-DSOLARUS_WRITE_DIR=\"${SOLARUS_WRITE_DIR}\")
endif()

# Quest size.
if(PANDORA)
  set(SOLARUS_INITIAL_DEFAULT_QUEST_WIDTH 400)
else()
  set(SOLARUS_INITIAL_DEFAULT_QUEST_WIDTH 320)
endif()
set(SOLARUS_DEFAULT_QUEST_WIDTH ${SOLARUS_INITIAL_DEFAULT_QUEST_WIDTH} CACHE STRING "Default width of the quest screen in pixels.")
set(SOLARUS_DEFAULT_QUEST_HEIGHT 240 CACHE STRING "Default height of the quest screen in pixels.")
if(SOLARUS_DEFAULT_QUEST_WIDTH)
  add_definitions(-DSOLARUS_DEFAULT_QUEST_WIDTH=${SOLARUS_DEFAULT_QUEST_WIDTH})
endif()
if(SOLARUS_DEFAULT_QUEST_HEIGHT)
  add_definitions(-DSOLARUS_DEFAULT_QUEST_HEIGHT=${SOLARUS_DEFAULT_QUEST_HEIGHT})
endif()

# Use OpenGL ES implementation.
set(SOLARUS_GL_ES "OFF" CACHE BOOL "Use OpenGL ES implementation.")
if(SOLARUS_GL_ES)
  add_definitions(-DSOLARUS_GL_ES)
endif()

# Enable logging of errors to file.
set(SOLARUS_FILE_LOGGING "ON" CACHE BOOL "Enable logging of errors to file.")
if(SOLARUS_FILE_LOGGING)
  add_definitions(-DSOLARUS_FILE_LOGGING)
endif()
