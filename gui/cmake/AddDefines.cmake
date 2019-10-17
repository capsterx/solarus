# Solarus GUI-specific -D preprocessor constants.

# Add defines for the install path and the build path to help guess the assets
# location at runtime
add_definitions(-DSOLARUS_GUI_TRANSLATIONS_DIR="${CMAKE_INSTALL_PREFIX}/${SOLARUS_GUI_SHARE_INSTALL_DESTINATION}/translations")
