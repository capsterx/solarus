# Add defines for the install path and the build path to help guess the assets
# location at runtime
add_definitions(-DSOLARUSGUI_TRANSLATION_PATH="${CMAKE_INSTALL_PREFIX}/${SOLARUSGUI_INSTALL_DATADIR}/translations")
