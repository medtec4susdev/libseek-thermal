SET(HEADERS
  SeekCam.h
  SeekDevice.h
  seek.h
  SeekLogging.h
  SeekThermal.h
  SeekThermalPro.h
)

SET(SOURCES
  SeekCam.cpp
  SeekDevice.cpp
  SeekThermal.cpp
  SeekThermalPro.cpp
)

INCLUDE_DIRECTORIES(
  ${OpenCV_INCLUDE_DIRS}
  ${LIBUSB_INCLUDE_DIRS}
)

ADD_LIBRARY(seek_static STATIC ${SOURCES} ${HEADERS})
ADD_LIBRARY(seek        SHARED ${SOURCES} ${HEADERS})

TARGET_LINK_LIBRARIES(seek
  ${OpenCV_LIBS}
  ${LIBUSB_LIBS}
)

# install library target and header files
INSTALL(
  TARGETS seek seek_static
  DESTINATION "bin"
  )

INSTALL(
  FILES ${HEADERS}
  DESTINATION "include/seek"
  )

# Copy DLLs to output/deps
IF (INSTALL_DLL)

  # LIBUSB
  INSTALL(FILES ${LIBUSB_LIBRARY_DIR}/libusb-1.0.dll DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)

  # OpenCV
  FOREACH(lib ${OpenCV_LIBS})
      GET_TARGET_PROPERTY(_debug_file ${lib} IMPORTED_LOCATION_DEBUG)
      GET_TARGET_PROPERTY(_release_file ${lib} IMPORTED_LOCATION_RELEASE)

      IF(MSVC OR ${CMAKE_GENERATOR} MATCHES "Xcode")
        # Release
        IF(EXISTS ${_release_file})
          INSTALL(FILES ${_release_file} DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
        ENDIF()
        # Debug
        IF(EXISTS ${_debug_file})
          INSTALL(FILES ${_debug_file} DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
        ENDIF()
      ELSE()
        IF(_debug_file EQUAL _release_file AND EXISTS ${_release_file})
          INSTALL(FILES ${_release_file} DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
        ELSE()
          IF(EXISTS ${_release_file})
            INSTALL(FILES ${_release_file} DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
          ENDIF()
          IF(EXISTS ${_debug_file})
            INSTALL(FILES ${_debug_file} DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
          ENDIF()
        ENDIF()
      ENDIF()
  ENDFOREACH()

ENDIF ()
