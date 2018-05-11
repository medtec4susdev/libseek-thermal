project(LibSeekThermal)
cmake_minimum_required(VERSION 2.8)

# Options
OPTION(BUILD_SHARED_LIBS      "Select shared or static library build"                                          ON)
OPTION(WITH_ADDRESS_SANITIZER "Enable address sanitizer"                                                       OFF)
OPTION(WITH_DEBUG_VERBOSITY   "Enable verbose stdout messages"                                                 OFF)
OPTION(BUILD_EXAMPLES         "Build the examples"                                                             OFF)
OPTION(INSTALL_DLL            "Copy DLL libs (OpenCV and LibUSB) to the output libs directory when installing" ON)

# CMake variables
SET(CMAKE_CXX_STANDARD 11)
SET(CMAKE_CXX_STANDARD_REQUIRED True)
SET(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")

IF(NOT DEFINED CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
ENDIF()
IF(NOT DEFINED CMAKE_LIBRARY_OUTPUT_DIRECTORY)
  SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
ENDIF()
IF(NOT DEFINED CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
  SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
ENDIF()

if (WITH_DEBUG_VERBOSITY)
  add_definitions(-DSEEK_DEBUG)
endif ()

# Build type
INCLUDE(build_type)
SET(default_build_type "Release")
if (NOT MSVC)
  MESSAGE(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
endif ()

# OpenCV and LibUSB
# SET(LibUSB_ROOT_DIR "C:/libusb-1.0.22")
SET(OpenCV_DIR "C:/PlusBuild/build/Deps/OpenCV-bin")
# FIND_PACKAGE(LibUSB REQUIRED)
FIND_PACKAGE(OpenCV REQUIRED NO_MODULE)

SET(LibUSB_DIR "C:/libusb-1.0.22")
SET(LibUSB_INCLUDE_DIRS ${LibUSB_DIR}/include)
SET(LibUSB_INCLUDES     ${LibUSB_DIR}/include)
SET(CMAKE_FIND_LIBRARY_PREFIXES "lib")
SET(CMAKE_FIND_LIBRARY_SUFFIXES ".lib" ".dll")
IF(MSVC OR ${CMAKE_GENERATOR} MATCHES "Xcode")
  SET(LibUSB_LIBRARY_DIR  ${LibUSB_DIR}/MS32/dll)  # 32bits
ELSE ()
  SET(LibUSB_LIBRARY_DIR  ${LibUSB_DIR}/MinGW32/dll)  # 32bits
ENDIF ()
FIND_LIBRARY(LibUSB_LIBS
  NAMES usb-1.0
  PATHS ${LibUSB_LIBRARY_DIR}
  NO_DEFAULT_PATH
  NO_CMAKE_ENVIRONMENT_PATH
  NO_CMAKE_PATH
  NO_SYSTEM_ENVIRONMENT_PATH
  NO_CMAKE_SYSTEM_PATH
  )

# CODE
ADD_SUBDIRECTORY(src)
IF (BUILD_EXAMPLES)
  ADD_SUBDIRECTORY(examples)
ENDIF ()
