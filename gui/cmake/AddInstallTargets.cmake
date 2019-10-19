# Default installation directories.
set(SOLARUS_GUI_SHARE_INSTALL_DESTINATION
  "${SOLARUS_SHARE_INSTALL_DESTINATION}/solarus-gui" CACHE PATH
  "GUI shared files install destination")

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
install(FILES
  ${solarus-gui_TRANSLATIONS_QM}
  DESTINATION "${SOLARUS_GUI_SHARE_INSTALL_DESTINATION}/translations"
)

# FreeDesktop compatible icons
if(UNIX AND NOT APPLE)
  # Pixmap icons for sizes under 48x48 pixels
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/images/icon/solarus_launcher_icon_16.png
    DESTINATION ${SOLARUS_SHARE_INSTALL_DESTINATION}/icons/hicolor/16x16/apps RENAME solarus-launcher.png)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/images/icon/solarus_launcher_icon_20.png
    DESTINATION ${SOLARUS_SHARE_INSTALL_DESTINATION}/icons/hicolor/20x20/apps RENAME solarus-launcher.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/images/icon/solarus_launcher_icon_24.png
    DESTINATION ${SOLARUS_SHARE_INSTALL_DESTINATION}/icons/hicolor/24x24/apps RENAME solarus-launcher.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/images/icon/solarus_launcher_icon_32.png
    DESTINATION ${SOLARUS_SHARE_INSTALL_DESTINATION}/icons/hicolor/32x32/apps RENAME solarus-launcher.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/images/icon/solarus_launcher_icon_48.png
    DESTINATION ${SOLARUS_SHARE_INSTALL_DESTINATION}/icons/hicolor/48x48/apps RENAME solarus-launcher.png)
  
  # Pixmap icon for desktop that don't support multiple sizes
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/images/icon/solarus_launcher_icon_512.png
    DESTINATION ${SOLARUS_SHARE_INSTALL_DESTINATION}/pixmaps RENAME solarus-launcher.png)

  # Vector icons, automatically chosen for sizes above 48x48 pixels
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/images/icon/solarus_launcher_icon.svg
    DESTINATION ${SOLARUS_SHARE_INSTALL_DESTINATION}/icons/hicolor/scalable/apps RENAME solarus-launcher.svg)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/images/icon/solarus_launcher_icon_symbolic.svg
    DESTINATION ${SOLARUS_SHARE_INSTALL_DESTINATION}/icons/hicolor/symbolic/apps RENAME solarus-launcher-symbolic.svg)
endif(UNIX AND NOT APPLE)

# FreeDesktop compatible start menu launcher
if(UNIX AND NOT APPLE)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/solarus-launcher.desktop
    DESTINATION ${SOLARUS_SHARE_INSTALL_DESTINATION}/applications)
endif(UNIX AND NOT APPLE)

# AppStream compatible software gallery metadata
if(UNIX AND NOT APPLE)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/solarus-launcher.appdata.xml
    DESTINATION ${SOLARUS_SHARE_INSTALL_DESTINATION}/appdata)
endif(UNIX AND NOT APPLE)

# Linux Manpage
if(UNIX AND NOT APPLE)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/solarus-launcher.6
    DESTINATION ${SOLARUS_MANUAL_INSTALL_DESTINATION}/man6)
endif(UNIX AND NOT APPLE)
