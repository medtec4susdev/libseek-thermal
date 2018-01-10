# Developed by MACBIOIDI-ULPGC & IACTEC-IAC group
PROJECT(SeekCameraLib)

SET(${PROJECT_NAME}_INCLUDE_DIRS
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}
  )

SET(${PROJECT_NAME}_SRCS
  SeekCam.cpp
  SeekDevice.cpp
  SeekThermal.cpp
  SeekThermalPro.cpp
 )

SET(${PROJECT_NAME}_HDRS
  seek.h
  SeekCam.h
  SeekDevice.h
  SeekLogging.h
  SeekThermal.h
  SeekThermalPro.h
  SeekCameraLibExport.h
  )

# create library
SET(LIB_TYPE STATIC)
IF(BUILD_SHARED_LIBS)
  SET(LIB_TYPE SHARED)
ENDIF()
ADD_LIBRARY(${PROJECT_NAME} ${LIB_TYPE} ${SeekCameraLib_SRCS} ${SeekCameraLib_HDRS})

# add include directories in the build
target_include_directories(${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

# link libraries for new library
target_link_libraries(${PROJECT_NAME} PUBLIC opencv_core opencv_imgcodecs LibUSB)
if(WIN32)
  target_link_libraries(${PROJECT_NAME} PUBLIC wsock32 ws2_32)
endif()

if (BUILD_SHARED_LIBS)
  # Enable generation of .lib file in MSVC when compiling shared libraries
  target_compile_definitions(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_EXPORTS)
else()
  target_compile_definitions(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_STATIC)
endif()

INSTALL(TARGETS ${PROJECT_NAME} EXPORT SeekCameraLib 
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION share
  )
INSTALL(FILES ${${PROJECT_NAME}_HDRS}
  DESTINATION include
  )

# Export the build configuration so that targets are made available
export(TARGETS
  SeekCameraLib
  FILE "${CMAKE_BINARY_DIR}/SeekCameraLibTargets.cmake"
  )

SET(SeekCameraLib_LIBRARIES SeekCameraLib)
SET(SeekCameraLib_TARGETS_FILE ${CMAKE_BINARY_DIR}/SeekCameraLibTargets.cmake)
# Configure the dependency config file so downstream projects can use us from CMake
CONFIGURE_FILE( 
  ${CMAKE_CURRENT_SOURCE_DIR}/SeekCameraLibConfig.cmake.in
  ${CMAKE_BINARY_DIR}/SeekCameraLibConfig.cmake
  @ONLY
  )