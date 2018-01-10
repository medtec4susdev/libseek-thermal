project(LibSeekThermal)
cmake_minimum_required(VERSION 3.3)

option (BUILD_SHARED_LIBS "Select shared or static library build" ON)
option (BUILD_EXAMPLES "Build the examples" OFF)
option (WITH_ADDRESS_SANITIZER "Enable address sanitizer" OFF)
option (WITH_DEBUG_VERBOSITY "Enable verbose stdout messages" OFF)

# Request C++11 standard, using new CMake variables.
set (CMAKE_CXX_STANDARD 11)
set (CMAKE_CXX_STANDARD_REQUIRED True)

set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

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

if (NOT MSVC)
  message (STATUS "Build type: ${CMAKE_BUILD_TYPE}")
endif ()

find_package (LibUSB REQUIRED)
find_package (OpenCV REQUIRED NO_MODULE)

add_subdirectory (src)

if (BUILD_EXAMPLES)
  add_subdirectory (examples)
endif ()