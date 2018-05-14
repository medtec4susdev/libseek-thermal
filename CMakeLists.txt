PROJECT(libseek-thermal)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# CMake variables
SET(CMAKE_CXX_STANDARD 11)
SET(CMAKE_CXX_STANDARD_REQUIRED True)
SET(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")

# Options
OPTION(WITH_ADDRESS_SANITIZER "Enable address sanitizer"                                                       OFF)
OPTION(WITH_DEBUG_VERBOSITY   "Enable verbose stdout messages"                                                 OFF)
OPTION(BUILD_EXAMPLES         "Build the examples"                                                             OFF)
OPTION(INSTALL_DLL            "Copy DLL libs (OpenCV and LibUSB) to the output libs directory when installing" ON)

IF (WITH_DEBUG_VERBOSITY)
  ADD_DEFINITIONS(-DSEEK_DEBUG)
ENDIF ()

# Build type
INCLUDE(build_type)
SET(default_build_type "Release")
if (NOT MSVC)
  MESSAGE(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
endif ()

# OpenCV
FIND_PACKAGE(LIBUSB REQUIRED)
FIND_PACKAGE(OpenCV REQUIRED NO_MODULE)

# CODE
ADD_SUBDIRECTORY(src)
IF (BUILD_EXAMPLES)
  ADD_SUBDIRECTORY(examples)
ENDIF ()
