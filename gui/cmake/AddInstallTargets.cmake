# Set files to install.
install(TARGETS solarus-gui solarus-launcher
  ARCHIVE DESTINATION ${SOLARUS_LIBRARY_INSTALL_DESTINATION}
  LIBRARY DESTINATION ${SOLARUS_LIBRARY_INSTALL_DESTINATION}
  RUNTIME DESTINATION ${SOLARUS_EXECUTABLE_INSTALL_DESTINATION}
)
install(DIRECTORY
  "${CMAKE_CURRENT_SOURCE_DIR}/include/solarus"
  DESTINATION ${SOLARUS_HEADERS_INSTALL_DESTINATION}
)
install(FILES
  ${solarus-gui_FORMS_HEADERS}
  DESTINATION "${SOLARUS_HEADERS_INSTALL_DESTINATION}/solarus/gui"
)

# FreeDesktop compatible icons
if(UNIX AND NOT APPLE)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/icons/solarus_icon_16.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/16x16/apps RENAME solarus.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/icons/solarus_icon_24.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/24x24/apps RENAME solarus.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/icons/solarus_icon_32.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/32x32/apps RENAME solarus.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/icons/solarus_icon_48.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/48x48/apps RENAME solarus.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/icons/solarus_icon_64.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/64x64/apps RENAME solarus.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/icons/solarus_icon_128.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/128x128/apps RENAME solarus.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/icons/solarus_icon_256.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/256x256/apps RENAME solarus.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/icons/solarus_icon_512.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/512x512/apps RENAME solarus.png)
endif(UNIX AND NOT APPLE)

# FreeDesktop compatible start menu launcher
if(UNIX AND NOT APPLE)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/../gui/resources/solarus.desktop
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/applications)
endif(UNIX AND NOT APPLE)

# AppStream compatible software gallery metadata
if(UNIX AND NOT APPLE)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/../gui/resources/solarus.appdata.xml
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/appdata)
endif(UNIX AND NOT APPLE)

# Linux Manpage
if(UNIX AND NOT APPLE)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/../solarus.6
    DESTINATION ${SOLARUS_MANUAL_INSTALL_DESTINATION}/man6)
endif(UNIX AND NOT APPLE)
