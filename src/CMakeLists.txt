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
  ${LibUSB_INCLUDE_DIRS}
)

ADD_LIBRARY(seek_static STATIC ${SOURCES} ${HEADERS})
ADD_LIBRARY(seek        SHARED ${SOURCES} ${HEADERS})

TARGET_LINK_LIBRARIES(seek
  ${OpenCV_LIBS}
  ${LibUSB_LIBS}
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

  # LibUSB
  INSTALL(FILES ${LibUSB_LIBRARY_DIR}/LibUSB-1.0.dll DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)

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

# Export the build configuration so that targets are made available
export(TARGETS
  seek seek_static
  FILE "${CMAKE_BINARY_DIR}/SeekCameraLibTargets.cmake"
  )

SET(SeekCameraLib_INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR} ${OpenCV_INCLUDE_DIRS} ${LibUSB_INCLUDE_DIRS})
SET(SeekCameraLib_SHARED_LIBRARIES seek)
SET(SeekCameraLib_STATIC_LIBRARIES seek_static)
SET(SeekCameraLib_TARGETS_FILE ${CMAKE_BINARY_DIR}/SeekCameraLibTargets.cmake)
# Configure the dependency config file so downstream projects can use us from CMake
CONFIGURE_FILE(
  ${CMAKE_CURRENT_SOURCE_DIR}/SeekCameraLibConfig.cmake.in
  ${CMAKE_BINARY_DIR}/SeekCameraLibConfig.cmake
  @ONLY
  )
